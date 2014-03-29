function init(args)
  self.sensors = sensors.create()
  self.movement = groundMovement.create(1, 1, setAnimationState)
  
  self.state = stateMachine.create({
    "moveState",
    "attackState",
	"chargeAttack"
  })
  self.state.leavingState = function(stateName)
    entity.stopFiring()
    entity.setDamageOnTouch(false)
    setAnimation("idle")
  end

  self.shieldHealth = entity.maxHealth() * entity.configParameter("shieldHealthRatio")

  entity.setAggressive(true)
  entity.setDeathParticleBurst("deathPoof")
  setAnimation("idle")
end

function main()
  local targetIdWas = self.targetId
  util.trackTarget(entity.configParameter("targetAcquisitionDistance"))
  if self.targetId ~= nil and self.targetId ~= 0 and self.targetId ~= targetIdWas then
    self.state.pickState(self.targetId)
  end

  self.state.update(entity.dt())
  self.sensors.clear()
end

function damage(args)
  if shieldIsUp() and self.shieldHealth > 0 then
    entity.heal(math.min(self.shieldHealth, args.damage))
    self.shieldHealth = math.max(0, self.shieldHealth - args.damage)
  end

  self.state.pickState(args.sourceId)
end

function move(toTarget)
  if setAnimation("move") then
    if math.abs(toTarget[2]) < 4.0 and isOnPlatform() then
		entity.moveDown()
    end
   if self.sensors.collisionSensors.collision.any(true) then
		entity.jump()
		setAnimation("jump")
    end
    entity.setFacingDirection(toTarget[1])
	entity.setRunning(true)
    if toTarget[1] < 0 then
      entity.moveLeft()
    else
      entity.moveRight()
	  end
	-- if setAnimation == "move" or "run" or "jump" then
	-- FIX THIS V
	-- entity.configParameter("movementSettings")
	-- THIS IS NOT RIGHT ^
	-- end 	
	
  end
end

function setAnimation(desiredAnimation)
  local animation = entity.animationState("movement")
	if animation == desiredAnimation then
    return true
	end
	
		if desiredAnimation == "shield" then
			if animation ~= "shield" and animation ~= "shieldStart" then
			entity.setAnimationState("movement", "shieldStart")
			end
		else
			if animation == "shield" or animation == "shieldStart" then
			entity.setAnimationState("movement", "shieldEnd")
			elseif animation ~= "shieldEnd" then
			entity.setAnimationState("movement", desiredAnimation)
			end
		end
		
--	if desiredAnimation ~= "shield" and animation ~= "shield" then
--		if desiredAnimation == "idle" then
--			if animation ~= "idle" and animation ~= "idleStart" then
--			entity.setAnimationState("movement", "idleStart")
--			end
--		else
--			if animation == "idle" or animation == "idleStart" then
--			entity.setAnimationState("movement", "idleEnd")
--			elseif animation ~= "idleEnd" then
--			entity.setAnimationState("movement", desiredAnimation)
--			end
--		end
--	end

  return false
end


function shieldIsUp()
  local animation = entity.animationState("movement")
  return animation == "shieldStart" or animation == "shield"
end

function isOnPlatform()
  return entity.onGround() and
    not self.sensors.nearGroundSensor.collisionTrace.any(true) and
    self.sensors.midGroundSensor.collisionTrace.any(true)
end

--------------------------------------------------------------------------------
moveState = {}

function moveState.enter()
  local direction
  if math.random(100) > 50 then
    direction = 1
	entity.setRunning(false)
  else
    direction = -1
	entity.setRunning(false)
  end
--  if setAnimation == "move" or "run" or "jump" then
-- entity.configParameter("movementSettings") = entity.configParameter("otherMovementSettings")
-- end 
 return {
    timer = entity.randomizeParameterRange("moveTimeRange"),
    direction = direction
  }
end

function moveState.update(dt, stateData)
  if self.sensors.collisionSensors.collision.any(true) then
	direction = -direction
  end

  if isOnPlatform() then
    entity.moveDown()
  end
  move({ stateData.direction, 0 })
  stateData.timer = stateData.timer - dt
  if stateData.timer <= 0 then
    return true, entity.configParameter("moveCooldownTime")
  end

  return false
end

--------------------------------------------------------------------------------
attackState = {}

function attackState.enterWith(targetId) 
  if targetId == 0 then return nil end
  if self.state.stateDesc() == "attackState" then return nil end
  self.targetId = targetId
end

function attackState.update(dt, stateData)
  if self.targetPosition ~= nil then
    local toTarget = world.distance(self.targetPosition, entity.position())
    local distance = world.magnitude(toTarget)

    if distance < entity.configParameter("attackDistance") and entity.onGround(true) then

        setAnimation("shield")
        entity.setDamageOnTouch(true)

      entity.setFacingDirection(toTarget[1])

      if self.targetPosition >= entity.configParameter("attackDistance") then
	  -- Attack the player ( Charge state? )
		entity.playSound(entity.randomizeParameter("painNoise"))
      end
    else
	move(toTarget)
    end
  end

  if self.targetId == nil then
    stateData.timer = stateData.timer - dt
  else
    stateData.timer = entity.configParameter("attackTargetHoldTime")
  end

  return stateData.timer <= 0
end