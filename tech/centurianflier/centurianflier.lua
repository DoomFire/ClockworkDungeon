function init()
  data.lastJump = false
  data.lastBoost = nil
  data.ranOut = false
  data.active = false
  data.activating = false
  data.deactivating = false
  data.specialLast = false
  data.animationDelay = 0.5
  data.testing = false

end

function uninit()
  if data.active then
    data.active = false
    tech.setVisible(false)
  end
end

function input(args)
 
 
  local currentJump = args.moves["jump"]
  local currentBoost = nil
  
 
	if args.moves["special"] == 1 and not data.specialLast then
      if data.active then 
        return "deactivate"
      else
        return "activate"
      end

  elseif not tech.onGround() and data.active then
    if not tech.canJump() and currentJump and not data.lastJump then
      if args.moves["right"] and args.moves["up"] then
        currentBoost = "boostRightUp"
      elseif args.moves["right"] and args.moves["down"] then
        currentBoost = "boostRightDown"
      elseif args.moves["left"] and args.moves["up"] then
        currentBoost = "boostLeftUp"
      elseif args.moves["left"] and args.moves["down"] then
        currentBoost = "boostLeftDown"
      elseif args.moves["right"] then
        currentBoost = "boostRight"
      elseif args.moves["down"] then
        currentBoost = "boostDown"
      elseif args.moves["left"] then
        currentBoost = "boostLeft"
      elseif args.moves["up"] then
        currentBoost = "boostUp"
		else
		currentBoost = "jetpack"
      end
    elseif currentJump and data.lastBoost then
      currentBoost = data.lastBoost
    end
  end

  ---------------------------
  
  data.lastJump = currentJump
  data.lastBoost = currentBoost
  data.specialLast = args.moves["special"] == 1

  return currentBoost
end

--gets run every "frame"/tick
function update(args)
  local boostControlForce = tech.parameter("boostControlForce")
  local boostSpeed = tech.parameter("boostSpeed")
  local energyUsagePerSecond = tech.parameter("energyUsagePerSecond")
  local energyUsage = energyUsagePerSecond * args.dt


--  	  world.logInfo("tech inliquid= "..tostring(tech.inLiquid))
--	  world.logInfo("actions[activate]= "..tostring(args.actions["activate"]))
--	  world.logInfo("------------------------------------------")

	  -- The problem is that args.actions["activate"] never becomes true
	  -- It should probably happen when the player presses F but I'm not sure how
	  
	  

	if not data.active and not tech.inLiquid and args.actions["activate"] then
  	  --start the activation animation and the timer

	  world.logInfo("active= "..tostring(data.active))
	  world.logInfo("delay= "..tostring(data.animationDelay))
	  world.logInfo("activating= "..tostring(data.activating))
	  world.logInfo("actions[activate]= "..tostring(args.actions["activate"]))
	  world.logInfo("------------------------------------------")
	  world.logInfo("------------------------------------------")

	  tech.setVisible(true)
	  tech.setAnimationState("flight", "activate")
	  data.activating = true
	if data.activating then
	  if data.animationDelay <= 0 then
        data.active = true
	    data.animationDelay = 0.5
	    data.activating=false
	  else
	    data.animationDelay = data.animationDelay - args.dt
	  end
    end
--so: if active or tech.inLiquid
  else
  	  --start the deactivation animation and the timer
	  tech.setAnimationState("flight", "deactivate")
	  data.deactivating = true
	  if data.deactivating then
	    if data.animationDelay <= 0 then
	      tech.setVisible(false)
          data.active = false
	      data.animationDelay = 0.5
	      data.deactivating=false
	    else
	      data.animationDelay = data.animationDelay - args.dt
	  end
    end
  end
  --------------------------------------------------------


  ----------------------
  ---- energy update? --
  ----------------------

--  if args.availableEnergy < energyUsage then
--    data.ranOut = true
--  elseif tech.onGround() then
--    data.ranOut = false
--  end

  local boosting = false
  local diag = 1 / math.sqrt(2)

  
  ---------------------
  --- I have no clue --
  ---------------------
  
--  if not data.ranOut then
--   boosting = true
--    if args.actions["boostRightUp"] then
--      tech.control({boostSpeed * diag, boostSpeed * diag}, boostControlForce, true, true)
--    elseif args.actions["boostRightDown"] then
--      tech.control({boostSpeed * diag, -boostSpeed * diag}, boostControlForce, true, true)
--    elseif args.actions["boostLeftUp"] then
--      tech.control({-boostSpeed * diag, boostSpeed * diag}, boostControlForce, true, true)
--    elseif args.actions["boostLeftDown"] then
--      tech.control({-boostSpeed * diag, -boostSpeed * diag}, boostControlForce, true, true)
--    elseif args.actions["boostRight"] then
--      tech.control({boostSpeed, 0}, boostControlForce, true, true)
--    elseif args.actions["boostDown"] then
--      tech.control({0, -boostSpeed}, boostControlForce, true, true)
--    elseif args.actions["boostLeft"] then
--      tech.control({-boostSpeed, 0}, boostControlForce, true, true)
--    elseif args.actions["boostUp"] then
--      tech.control({0, boostSpeed}, boostControlForce, true, true)
--    elseif args.actions["jetpack"] then	
--	  tech.control({0, 0}, boostControlForce, true, true)
--	else
--      boosting = false
--    end
--  end


-----------------------
-------boosting--------
-----------------------

--  if boosting then
--    tech.setAnimationState("flight", "hover")
--    tech.setParticleEmitterActive("boostParticles", true)
--    return energyUsage
--  elseif tech.onGround() and data.testing then
--	tech.setAnimationState("flight", "crouch")
--	tech.setParticleEmitterActive("exhaustParticles", false)
--	return 0
--  else
--    tech.setAnimationState("flight", "default")
--    tech.setParticleEmitterActive("boostParticles", false)
--    return 0
--  end
end