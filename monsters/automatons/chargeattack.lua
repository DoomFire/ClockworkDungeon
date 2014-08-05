chargeAttack = {}

function chargeAttack.enter()
  if not canStartAttack() then return nil end

  -- Don't start a charge attack if we're blocked or about to fall
  if isBlocked() or willFall() then
    return nil
  end

  local chargeAttackDirection = 0
  if self.toTarget[1] < 0 then
    chargeAttackDirection = -1
    entity.setFacingDirection(-1)
  else
    chargeAttackDirection = 1
    entity.setFacingDirection(1)
  end

  return {
    chargeAttackWindupTime = entity.configParameter("chargeAttackWindupTime"),
    chargeAttackDirection = chargeAttackDirection
  }
end

function chargeAttack.enteringState(stateData)
  entity.setAnimationState("attack", "idle")
  setAggressive(true, true)

  entity.setActiveSkillName("chargeAttack")
end

function chargeAttack.update(dt, stateData)
  if not canContinueAttack() then return true end

  if stateData.chargeAttackWindupTime > 0 then
    stateData.chargeAttackWindupTime = stateData.chargeAttackWindupTime - dt
    entity.setRunning(false)
    entity.setAnimationState("movement", "chargeWindup")

    if stateData.chargeAttackWindupTime <= 0 then
      local projectile = entity.configParameter("chargeAttackProjectile", nil)
      if projectile ~= nil then
        entity.setFireDirection({0,0}, { stateData.chargeAttackDirection, 0 })
        entity.startFiring(projectile)
      end
    end
  else
    entity.setRunning(true)
    if stateData.chargeAttackDirection < 0 then
      entity.moveLeft()
    else
      entity.moveRight()
    end
    entity.setAnimationState("movement", "charge")

    if entity.animationState("attack") ~= "chargeAttack" then
      if math.abs(self.toTarget[1]) < entity.configParameter("chargeAttackAttackDistance") then
        entity.setAnimationState("attack", "chargeAttack")
        entity.playSound(entity.randomizeParameter("attackNoise"))
      elseif self.toTarget[1] * entity.facingDirection() > 0 then
        entity.setAnimationState("attack", "charge")
      else
        entity.stopFiring()
        return true
      end
    else
      if math.abs(self.toTarget[1]) > entity.configParameter("chargeAttackAttackDistance") then
        entity.stopFiring()
        return true
      end
    end
  end

  return false
end
