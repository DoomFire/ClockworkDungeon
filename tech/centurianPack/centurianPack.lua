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
  data.jumping = false
  data.hovering = false
  
  
end

function uninit()
  if data.active then
    tech.setVisible(false)
--    tech.translate({0, -tech.parameter("ballTransformHeightChange")})
--    tech.setParentAppearance("normal")
--    tech.setToolUsageSuppressed(false)
    data.active = false
  end
end

function input(args)

  local move = nil
 
-- look if F is pressed
		--"special" == pressing F
  if args.moves["special"] == 1 and not data.specialLast then
    
	if data.active then
    
		data.hovering = false
		return "morphballDeactivate"
    
	else
		data.hovering = false
      return "centurainPackActivate"
    end
	
	
-- if F isn't pressed then ...	
	elseif data.active then

		
		if  args.moves["up"] and not tech.onGround() then 	--		and args.moves["jump"] then-- 
--			world.logInfo("DoubleJump")
--			return "superjump"
			data.hovering = true	
		else
			 data.hovering = false
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

  
  
			if  data.hovering then
				tech.yControl(0, 600, true)
				tech.applyMovementParameters({gravityEnabled = false})
			else
				tech.applyMovementParameters({gravityEnabled = true})
			end
  
  
  
  if not data.active and args.actions["centurainPackActivate"] then
    tech.setAnimationState("morphball", "activate")
    tech.setVisible(true)
--    tech.translate({0, ballTransformHeightChange})
--    tech.setParentAppearance("hidden")
   
--    tech.setToolUsageSuppressed(true)

   data.active = true
  elseif data.active and (args.actions["morphballDeactivate"]) then
	  --start the deactivation animation and the timer
	  tech.setAnimationState("morphball", "deactivate")
	  data.deactivating=true
  end

  

  if data.active then

  
  
-- 	  if we have to turn off, then count down the timer
	if data.deactivating then
	  if data.animationDelay <= 0 then
      tech.setVisible(false)

--	  can we use Items while flying?
      tech.setToolUsageSuppressed(false)

      data.angle = 0
      data.active = false
	  data.animationDelay = 0.5
	  data.deactivating=false
	  else
	  data.animationDelay = data.animationDelay - args.dt
	  end
    end
	
	
	-- grounc check
	
	
	
	if tech.onGround() then
		data.jumping=false
	end
	
	

	
	
	
	-- Super Jump
  local energyUsage = tech.parameter("energyUsage")
  local superJumpSpeed = tech.parameter("superjumpSpeed")
  local superJumpControlForce = tech.parameter("superjumpControlForce")
  local superJumpTime = tech.parameter("superjumpTime")
  local superjumpSound = tech.parameter("superjumpSound")

  local usedEnergy = 0

  if args.actions["superjump"] then-- and tech.onGround() and data.superJumpTimer <= 0 and args.availableEnergy > energyUsage then
    tech.jump(true)
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
