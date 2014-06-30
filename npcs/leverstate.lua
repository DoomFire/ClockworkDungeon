leverState = {}

function leverState.enterWith(args)
  if args.attackTargetId == nil then return nil end
  if stateName() == "leverState" then return nil end

  return {
    reactionTimer = entity.randomizeParameterRange("lever.reactionTimeRange"),
    targetId = args.attackTargetId,
    sourceId = args.attackSourceId,
    wasSourceEntity = wasSourceEntity,
    safeTimer = entity.configParameter("lever.safeTimer"),
    dialogTimer = entity.randomizeParameterRange("lever.dialogTimeRange"),
    foundProtector = false,
    lastPosition = entity.position(),
    stuckTimer = 0,
	activatedSwitch=false,
	wittyRemark=false,
	buttonDelay=0,
	lastButton=0
  }
end

function leverState.update(dt, stateData)
  local targetPosition = world.entityPosition(stateData.targetId)
  if targetPosition == nil then
    return true
  end
  local position = entity.position()
  local fromTarget = world.distance(position, targetPosition)

  -- It can take a moment to react to whatever just happened
  if stateData.reactionTimer > 0 then
    setFacingDirection(-fromTarget[1])

    stateData.reactionTimer = stateData.reactionTimer - dt
    if stateData.reactionTimer <= 0 then
      -- If this npc just saw another npc get attacked, they'll behave differently
      -- than if they were attacked themself
      local wasSourceEntity = stateData.sourceId == entity.id()
      if wasSourceEntity then
        sayToTarget("lever.dialog.helpme", stateData.targetId)
      else
        sayToTarget("lever.dialog.helpthem", stateData.targetId)
      end
    else
      return false
    end
  end
  
  -- If you can find a lever to flip and you're relatively safe, try and activate the alarm  
  local buttonLocation,buttonID = leverState.findLever()
  local ButtonDistance=nil
--	entity.say(tostring(stateData.activatedSwitch), nil)
    if buttonLocation then
--	entity.say("buttonLocation = "..tostring(buttonLocation[1]))
	ButtonDistance =world.distance(buttonLocation, entity.position())
	
	end
	
--entity.say("last button= "..tostring(stateData.lastButton).."          button id= "..tostring(buttonID[1]))	
  if buttonLocation and (not stateData.activatedSwitch or (world.magnitude(ButtonDistance)<10 and not(stateData.lastButton==buttonID[1]) )) then 
  --and world.magnitude(fromTarget) > entity.configParameter("lever.dangerDistance") and not stateData.activatedALever then
	

	--	entity.say(tostring(world.magnitude(ButtonDistance)),nil)
	if world.magnitude(ButtonDistance) < 3 then
		
		if not stateData.wittyRemark then
			stateData.wittyRemark=true
			entity.say("Automatons, roll out!!", nil)
		elseif stateData.buttonDelay>=50*dt then
			stateData.activatedSwitch=true
			stateData.buttonDelay=0
			stateData.wittyRemark=false
			world.callScriptedEntity(buttonID[1], "onInteraction")
			stateData.lastButton=buttonID[1]
		else
			stateData.buttonDelay= stateData.buttonDelay+1
		end
	else 
	
	moveTo(buttonLocation,dt,{ run = true})
	end
--	entity.say(to
--	local leverPosition = world.entityPosition(buttonLocation)
--	leverPosition[2] = leverPosition[2] + 1.0
--    local toLever = world.distance(leverPosition, position)
--	
--    if world.magnitude(toLever) < entity.configParameter("lever.leverRadius") and not world.lineCollision(position, leverPosition, true) then
--      world.callScriptedEntity(buttonLocation, "onInteraction")
--	  stateData.activatedALever = true
    
--	else
--	  moveTo(leverPosition, dt)
--	end


  else 
  -- Try to move a safe distance away
  local safeDistance
  if stateData.foundProtector then
    safeDistance = entity.configParameter("lever.safeDistanceWithGuards")
  else
    safeDistance = entity.configParameter("lever.safeDistance")
  end

  local safe = not entity.entityInSight(stateData.targetId) or world.magnitude(fromTarget) > safeDistance

  if safe then
    stateData.safeTimer = stateData.safeTimer - dt
    if stateData.safeTimer < 0 then
      return true
    end
  else
    moveTo(targetPosition, dt, { run = true, fleeDistance = safeDistance })

    -- Don't stay stuck running against a wall
    if position[1] == stateData.lastPosition[1] then
      stateData.stuckTimer = stateData.stuckTimer + dt
      if stateData.stuckTimer >= entity.configParameter("lever.stuckTime") then
        return true, entity.configParameter("lever.stuckCooldown")
      end
    else
      stateData.stuckTimer = 0
    end

    stateData.safeTimer = entity.configParameter("lever.safeTimer")
  end
 end
  stateData.lastPosition = position

  if stateData.wasSourceEntity then
    if sendNotification("attack", { targetId = stateData.targetId, sourceId = entity.id(), sourceDamageTeam = entity.damageTeam() }) then
      if not stateData.foundProtector then
        local attackerIds = world.npcQuery(entity.position(), 25.0, { callScript = "isAttacking" })
        if #attackerIds > 0 then
          stateData.foundProtector = true
        end
      end
    end

    stateData.dialogTimer = stateData.dialogTimer - dt
    if stateData.dialogTimer <= 0 then
      if stateData.foundProtectors then
        sayToTarget("lever.dialog.encourage", stateData.sourceId)
      elseif safe then
        sayToTarget("lever.dialog.safe", stateData.sourceId)
      else
        sayToTarget("lever.dialog.help", stateData.sourceId)
      end

      stateData.dialogTimer = entity.randomizeParameterRange("lever.dialogTimeRange")
    end
  end

  return false
end


function leverState.findLever()
	
	local leverIds = world.objectQuery(entity.position(), entity.configParameter("lever.searchDistance"), {order = "nearest", name = "clockbutton"})

	if leverIds and leverIds[1] then		
			-- entity.position() returns bottom-left of the entity. We need to adjust
			
--					world.callScriptedEntity(leverIds[1], "onInteraction")
			local location = world.entityPosition(leverIds[1])
			location = {location[1], location[2]+2}
--			entity.say("findlever = "..tostring(leverIds[1]).."        return location: "..tostring(location[1]))
			return location,leverIds
	end
	return nill,nill

	
	
end