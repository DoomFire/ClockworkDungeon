function init()
  self.position = {0, 0}
  self.target = 0
  self.toTarget = { 0, 0 }
  
  self.lastAggressGroundPosition = {0, 0}

  self.dead = false

  self.targetSearchTimer = 0
  self.targetHoldTimer = 0
  self.idleSoundTimer = 0
  self.jumpTimer = 0
  self.attackCooldownTimer = 0
  self.attackTimer = 0
  self.exhaustionTimer = entity.configParameter("exhaustionTimer")
  self.exhaustionCooldownTimer = 0
  self.painSoundTimer = 0

  local states = stateMachine.scanScripts(entity.configParameter("scripts"), "(%a+State)%.lua")
  local attacks = stateMachine.scanScripts(entity.configParameter("scripts"), "(%a+Attack)%.lua")
  for _, attack in pairs(attacks) do
    table.insert(states, attack)
  end

  self.state = stateMachine.create(states)

  self.state.enteringState = function(stateName)
    if isAttackState(stateName) then
      setAggressive(true, true)
      self.attackTimer = entity.configParameter("attackTime", math.huge)
    end
  end

  self.state.leavingState = function(stateName)
    self.state.shuffleStates()

    entity.setActiveSkillName(nil)
    if isAttackState(stateName) then
      setAggressive(false, false)
      self.attackCooldownTimer = entity.configParameter("attackCooldownTime")
    end
  end

  entity.setDeathSound(entity.randomizeParameter("deathNoise"))
  entity.setDeathParticleBurst(entity.configParameter("deathParticles"))
end

--------------------------------------------------------------------------------
function damage(args)

  self.exhaustionCooldownTimer = 0

  if args.sourceId ~= self.target then
    setTarget(args.sourceId)
  end

  if self.painSoundTimer <= 0 then
    entity.playSound(entity.randomizeParameter("painNoise"))
    self.painSoundTimer = entity.configParameter("painSoundTimer")
  end

  if entity.health() <= 0 then
    if self.state.pickState({ knockout = true }) then
      world.callScriptedEntity(args.sourceId, "monsterKilled", entity.id())
    end
  end

  local entityId = entity.id()
  local damageNotificationRegion = entity.configParameter("damageNotificationRegion", { -10, -4, 10, 4 })
  world.monsterQuery(
    vec2.add({ damageNotificationRegion[1], damageNotificationRegion[2] }, self.position),
    vec2.add({ damageNotificationRegion[3], damageNotificationRegion[4] }, self.position),
    {
      withoutEntityId = entityId,
      inSightOf = entityId,
      callScript = "monsterDamaged",
      callScriptArgs = { entityId, entity.seed(), args.sourceId }
    }
  )
end

--------------------------------------------------------------------------------
function shouldDie()
  return self.dead
end

--------------------------------------------------------------------------------
function main()
  self.position = entity.position()

  if storage.basePosition == nil then
    storage.basePosition = self.position
  end

  local dt = entity.dt()

  if entity.stunned() and not knockedOut() then
    entity.setAnimationState("movement", "knockback")
    entity.setAnimationState("attack", "idle")
    setAggressive(true, false)
  else
    checkTerritory()
    track()

    if not attacking() and canStartAttack() then
      self.state.pickState()
    end

    if not self.state.update(dt) then
      -- Force wandering, even if there is a target that can be attacked
      self.state.pickState({ wander = true })
    end
  end

  decrementTimers()
end

--------------------------------------------------------------------------------
function move(delta, jumpThresholdX)
  if delta[1] > 0 then
    entity.setFacingDirection(1)
    entity.moveRight()
  elseif delta[1] < 0 then
    entity.setFacingDirection(-1)
    entity.moveLeft()
  end

  local onGround = entity.onGround()

  if self.jumpTimer > 0 and not onGround then
    entity.holdJump()
  else
    if self.jumpTimer <= 0 then
      if jumpThresholdX == nil then jumpThresholdX = 4 end

      -- We either need to be blocked by something, the target is above us and
      -- we are about to fall, or the target is significantly high enough above
      -- us
      local jump = false
      if isBlocked() then
        jump = true
      elseif (delta[2] >= 0 and willFall()) then
        jump = true
      elseif (math.abs(delta[1]) < jumpThresholdX and delta[2] > entity.configParameter("jumpTargetDistance")) then
        jump = true
      end

      if jump then
        self.jumpTimer = entity.randomizeParameterRange("jumpTime")
        entity.jump()
      end
    end
  end

  if delta[2] < 0 then
    entity.moveDown()
  end

  if not onGround then
    entity.setAnimationState("movement", "jump")
  elseif delta[1] ~= 0 then
    entity.setAnimationState("movement", "run")
  else
    entity.setAnimationState("movement", "idle")
  end
end

--------------------------------------------------------------------------------
function canStartAttack()
  return hasTarget() and
    not knockedOut() and
    world.magnitude(self.toTarget) <= entity.configParameter("attackStartDistance") and
    self.attackCooldownTimer <= 0
end

--------------------------------------------------------------------------------
function canContinueAttack()
  return hasTarget() and
    self.attackTimer > 0 and
    world.magnitude(self.toTarget) <= entity.configParameter("attackMaxDistance", math.huge)
end

--------------------------------------------------------------------------------
function setTarget(target)
  if target ~= 0 then
    self.targetHoldTimer = entity.configParameter("targetHoldTime")

    if self.target ~= target then
      entity.playSound(entity.randomizeParameter("turnHostileNoise"))
    end
  end

  self.target = target
end

--------------------------------------------------------------------------------
function isBlocked(direction)
  local reverse = false
  if direction ~= nil then
    reverse = direction ~= entity.facingDirection()
  end

  for i, sensor in ipairs(entity.configParameter("blockedSensors")) do
    if reverse then
      sensor[1] = -sensor[1]
    end

    world.debugPoint(entity.toAbsolutePosition(sensor), "Blue")
    if world.pointCollision(entity.toAbsolutePosition(sensor), true) then
      return true
    end
  end
  return false
end

--------------------------------------------------------------------------------
function willFall(direction)
  local reverse = false
  if direction ~= nil then
    reverse = direction ~= entity.facingDirection()
  end

  for i, sensor in ipairs(entity.configParameter("fallSensors")) do
    if reverse then
      sensor[1] = -sensor[1]
    end

    world.debugPoint(entity.toAbsolutePosition(sensor), "Red")
    if world.pointCollision(entity.toAbsolutePosition(sensor), false) then
      return false
    end
  end
  return true
end

--------------------------------------------------------------------------------
function track()
  -- Keep holding on our target while we are attacking
  if not world.entityExists(self.target) or (not attacking() and self.targetHoldTimer <= 0) then
    setTarget(0)
  end

  if self.aggressive and self.target == 0 and self.targetSearchTimer <= 0 then
    -- Use either the territorialTargetRadius or the minimalTargetRadius,
    -- depending on whether we are in our territory or not
    local targetId
    if self.territory == 0 then
      targetId = entity.closestValidTarget(entity.configParameter("territorialTargetRadius"))
    else
      targetId = entity.closestValidTarget(entity.configParameter("minimalTargetRadius"))
    end

    if targetId ~= 0 then
      -- Pets don't attack npcs unless they are attacking the owner
      if isCaptive() and world.isNpc(targetId) and world.callScriptedEntity(targetId, "attackTargetId") ~= self.ownerEntityId then
        targetId = 0
      end

      setTarget(targetId)
    end

    self.targetSearchTimer = entity.configParameter("targetSearchTime")
  end

  if self.target == 0 then
    self.toTarget = {0, 0}
  else
    self.toTarget = entity.distanceToEntity(self.target)
  end
end

--------------------------------------------------------------------------------
function attacking()
  local stateName = self.state.stateDesc()

  if stateName == nil then
    stateName = ""
  end

  return isAttackState(stateName)
end

--------------------------------------------------------------------------------
function isAttackState(stateName)
  return string.find(stateName, 'Attack$')
end

--------------------------------------------------------------------------------
function calculateSeparationMovement()
  local entityIds = world.monsterQuery(self.position, 0.5, { withoutEntityId = entity.id(), order = "nearest" })
  if #entityIds > 0 then
    local separationMovement = world.distance(self.position, world.entityPosition(entityIds[1]))
    return util.toDirection(separationMovement[1])
  end

  return 0
end

--------------------------------------------------------------------------------
function decrementTimers()
  dt = entity.dt()

  self.targetSearchTimer = self.targetSearchTimer - dt
  self.idleSoundTimer = self.idleSoundTimer - dt
  self.jumpTimer = self.jumpTimer - dt
  self.targetHoldTimer = self.targetHoldTimer - dt
  self.attackCooldownTimer = self.attackCooldownTimer - dt
  self.attackTimer = self.attackTimer - dt
  self.exhaustionCooldownTimer = self.exhaustionCooldownTimer - dt
  self.painSoundTimer = self.painSoundTimer - dt
end

--------------------------------------------------------------------------------
function setAggressive(enabled, damageOnTouch)
  if enabled then
    entity.setAggressive(true)
  else
    local aggressive = entity.configParameter("alwaysAggressive", false)
    entity.setAggressive(aggressive)
    if not aggressive then
      damageOnTouch = false
    end
  end

  if damageOnTouch then
    entity.setDamageOnTouch(true)
    entity.setParticleEmitterActive("damage", true)
  else
    entity.setDamageOnTouch(false)
    entity.setParticleEmitterActive("damage", false)
  end
end

--------------------------------------------------------------------------------
function hasTarget()
  return self.target ~= 0
end