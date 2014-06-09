flee2State = {}

function flee22State.enterWith(args)
  if args.attackTargetId == nil then return nil end
  if stateName() == "flee2State" then return nil end

  return {
    reactionTimer = entity.randomizeParameterRange("flee2.reactionTimeRange"),
    targetId = args.attackTargetId,
    sourceId = args.attackSourceId,
    wasSourceEntity = wasSourceEntity,
    safeTimer = entity.configParameter("flee2.safeTimer"),
    dialogTimer = entity.randomizeParameterRange("flee2.dialogTimeRange"),
    foundProtector = false,
    lastPosition = entity.position(),
    stuckTimer = 0,
  }
end

function flee2State.update(dt, stateData)
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
        sayToTarget("flee2.dialog.helpme", stateData.targetId)
      else
        sayToTarget("flee2.dialog.helpthem", stateData.targetId)
      end
    else
      return false
    end
  end

  -- Try to move a safe distance away
  local safeDistance
  if stateData.foundProtector then
    safeDistance = entity.configParameter("flee2.safeDistanceWithGuards")
  else
    safeDistance = entity.configParameter("flee2.safeDistance")
  end

  local safe = not entity.entityInSight(stateData.targetId) or world.magnitude(fromTarget) > safeDistance

  if safe then
    stateData.safeTimer = stateData.safeTimer - dt
    if stateData.safeTimer < 0 then
      return true
    end
  else
    moveTo(targetPosition, dt, { run = true, flee2Distance = safeDistance })

    -- Don't stay stuck running against a wall
    if position[1] == stateData.lastPosition[1] then
      stateData.stuckTimer = stateData.stuckTimer + dt
      if stateData.stuckTimer >= entity.configParameter("flee2.stuckTime") then
        return true, entity.configParameter("flee2.stuckCooldown")
      end
    else
      stateData.stuckTimer = 0
    end

    stateData.safeTimer = entity.configParameter("flee2.safeTimer")
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
        sayToTarget("flee2.dialog.encourage", stateData.sourceId)
      elseif safe then
        sayToTarget("flee2.dialog.safe", stateData.sourceId)
      else
        sayToTarget("flee2.dialog.help", stateData.sourceId)
      end

      stateData.dialogTimer = entity.randomizeParameterRange("flee2.dialogTimeRange")
    end
  end

  return false
end
