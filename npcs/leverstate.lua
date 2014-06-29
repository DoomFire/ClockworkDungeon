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
	activatedALever = false,
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
  local entityId = leverState.findLever()
  world.logInfo("testing: " .. tostring(entityId))
	
  if entityId
  --and world.magnitude(fromTarget) > entity.configParameter("lever.dangerDistance") and not stateData.activatedALever 
  then
	world.logInfo("")
	world.logInfo("Testing")
	world.logInfo("")
	moveTo(entityId,dt)
	
	
--	local leverPosition = world.entityPosition(entityId)
--	leverPosition[2] = leverPosition[2] + 1.0
--    local toLever = world.distance(leverPosition, position)
--	
--    if world.magnitude(toLever) < entity.configParameter("lever.leverRadius") and not world.lineCollision(position, leverPosition, true) then
--      world.callScriptedEntity(entityId, "onInteraction")
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
	world.logInfo("")
	world.logInfo("---------------------------------------------------------------------")
	
	world.logInfo("position= ".. tostring(entity.position()))
	world.logInfo("configParameter= ".. tostring(entity.configParameter("lever.searchDistance")))
	world.logInfo("query test= "..tostring(world.objectQuery(entity.position(), entity.configParameter("lever.searchDistance"), {name = "upperclass"})))
 	local leverIds = world.objectQuery(entity.position(), entity.configParameter("lever.searchDistance"), {order = "nearest", name = "upperclass"})

--	 for _, leverIds in pairs(leverIds) do
 --         world.callScriptedEntity(doorId, "closeDoor")
--        end

	world.logInfo("leverIds= "..tostring(leverIds))
	world.logInfo("---------------------------------------------------------------------")
	world.logInfo("")
	



	if leverIds and leverIds[1] then		
			-- entity.position() returns bottom-left of the entity. We need to adjust
			local location = world.entityPosition(leverIds[1])
			location = {location[1], location[2]+2}
			return location
	end
	return leverIds

	
	
end