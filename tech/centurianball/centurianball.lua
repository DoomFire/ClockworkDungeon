function init()
  data.specialLast = false
  data.jumpLast = false
  data.angularVelocity = 0
  data.angle = 0
  data.active = false
  tech.setVisible(false)
  data.superJumpTimer = 0
  data.animationDelay = 0.5
  data.deactivating=false
end

function uninit()
  if data.active then
    tech.setVisible(false)
    tech.translate({0, -tech.parameter("ballTransformHeightChange")})
    tech.setParentAppearance("normal")
    tech.setToolUsageSuppressed(false)
    data.active = false
  end
end

function input(args)
  local move = nil
  if args.moves["special"] == 1 and not data.specialLast then
    if data.active then
      return "morphballDeactivate"
    else
      return "morphballActivate"
    end
	
    elseif data.active then
      if args.moves["jump"] and args.moves["up"] and tech.onGround() then
        return "superjump"
	  end
  end
 
  data.specialLast = args.moves["special"] == 1
  data.jumpLast = args.moves["jump"]
  
  return move
end

function update(args)
  local energyCostPerSecond = tech.parameter("energyCostPerSecond")
  local ballCustomMovementParameters = tech.parameter("ballCustomMovementParameters")
  local ballTransformHeightChange = tech.parameter("ballTransformHeightChange")
  local ballDeactivateCollisionTest = tech.parameter("ballDeactivateCollisionTest")
  local ballRadius = tech.parameter("ballRadius")
  local ballFrames = tech.parameter("ballFrames")

  if not data.active and args.actions["morphballActivate"] then
    tech.setAnimationState("morphball", "activate")
    tech.setVisible(true)
    tech.translate({0, ballTransformHeightChange})
    tech.setParentAppearance("hidden")
    tech.setToolUsageSuppressed(true)
    data.active = true
  elseif data.active and (args.actions["morphballDeactivate"] or energyCostPerSecond * args.dt > args.availableEnergy) then
    ballDeactivateCollisionTest[1] = ballDeactivateCollisionTest[1] + tech.position()[1]
    ballDeactivateCollisionTest[2] = ballDeactivateCollisionTest[2] + tech.position()[2]
    ballDeactivateCollisionTest[3] = ballDeactivateCollisionTest[3] + tech.position()[1]
    ballDeactivateCollisionTest[4] = ballDeactivateCollisionTest[4] + tech.position()[2]
    
	if not world.rectCollision(ballDeactivateCollisionTest) then
	  --start the deactivation animation and the timer
	  tech.setAnimationState("morphball", "deactivate")
	  data.deactivating=true
    else
      -- Make some kind of error noise if not auto-deactivating
    end
  end


  if data.active then
    tech.applyMovementParameters(ballCustomMovementParameters)
	-- if we have to turn off, then count down the timer
	if data.deactivating then
	  if data.animationDelay <= 0 then
      tech.setVisible(false)
      tech.translate({0, -ballTransformHeightChange})
      tech.setParentAppearance("normal")
      tech.setToolUsageSuppressed(false)
      data.angle = 0
      data.active = false
	  data.animationDelay = 0.5
	  data.deactivating=false
	  else
	  data.animationDelay = data.animationDelay - args.dt
	  end
    end
	
	
    if tech.onGround() then
      -- If we are on the ground, assume we are rolling without slipping to
      -- determine the angular velocity
      data.angularVelocity = -tech.measuredVelocity()[1] / ballRadius
    end

    data.angle = math.fmod(math.pi * 2 + data.angle + data.angularVelocity * args.dt, math.pi * 2)

    -- Rotation frames for the ball are given as one *half* rotation so two
    -- full cycles of each of the ball frames completes a total rotation.
    local rotationFrame = math.floor(data.angle / math.pi * ballFrames) % ballFrames
    tech.setGlobalTag("rotationFrame", rotationFrame)
	
	-- Super Jump
  local energyUsage = tech.parameter("energyUsage")
  local superJumpSpeed = tech.parameter("superjumpSpeed")
  local superJumpControlForce = tech.parameter("superjumpControlForce")
  local superJumpTime = tech.parameter("superjumpTime")
  local superjumpSound = tech.parameter("superjumpSound")

  local usedEnergy = 0

  if args.actions["superjump"] and tech.onGround() and data.superJumpTimer <= 0 and args.availableEnergy > energyUsage then
    tech.playImmediateSound(superjumpSound)
    data.superJumpTimer = superJumpTime
    usedEnergy = energyUsage
  end

   if data.superJumpTimer > 0 then
    tech.yControl(superJumpSpeed, superJumpControlForce)
    data.superJumpTimer = data.superJumpTimer - args.dt
  end
  
  if usedEnergy ~= 0 then
    return usedEnergy
  end
  
    return energyCostPerSecond * args.dt
  end

  return 0
end
