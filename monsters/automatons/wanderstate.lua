wanderState = {}

function wanderState.enter()
  if hasTarget() or isCaptive() then return nil end

  return {
    wanderTimer = entity.randomizeParameterRange("wanderTime"),
    wanderMovementTimer = entity.randomizeParameterRange("wanderMovementTime"),
    wanderFlipTimer = 0,
    movement = util.randomDirection()
  }
end

function wanderState.enterWith(params)
  if isCaptive() then return nil end

  if params.wander then
    return {
      wanderTimer = entity.randomizeParameterRange("wanderTime"),
      wanderMovementTimer = entity.randomizeParameterRange("wanderMovementTime"),
      movement = util.randomDirection()
    }
  end

  return nil
end

function wanderState.update(dt, stateData)
  if hasTarget() then return true end

  entity.setRunning(false)

  if self.jumpTimer > 0 and not entity.onGround() then
    entity.holdJump()
  elseif self.territory ~= 0 then
    if isBlocked() or willFall() then
      storage.basePosition = self.position
    else
      stateData.movement = self.territory
      stateData.wanderTimer = entity.randomizeParameterRange("wanderTime")
      stateData.wanderMovementTimer = entity.randomizeParameterRange("wanderMovementTime")
    end
  elseif stateData.movement ~= 0 and (willFall() or isBlocked()) then
    if math.random() < entity.configParameter("wanderJumpProbability") then
      self.jumpTimer = entity.randomizeParameterRange("jumpTime")
      entity.jump()
    elseif stateData.wanderFlipTimer <= 0 then
      stateData.movement = -stateData.movement
      stateData.wanderTimer = entity.randomizeParameterRange("wanderTime")
      stateData.wanderFlipTimer = entity.configParameter("wanderFlipTimer") or 0.5
    end
  else
    if stateData.wanderTimer <= 0 then
      return true
    end
  end

  if stateData.movement == 1 then
    entity.setFacingDirection(1)
    entity.moveRight()
  elseif stateData.movement == -1 then
    entity.setFacingDirection(-1)
    entity.moveLeft()
  end

  entity.setAnimationState("attack", "idle")
  if not entity.onGround() then
    entity.setAnimationState("movement", "jump")
  elseif stateData.movement ~= 0 then
    entity.setAnimationState("movement", "walk")
  else
    entity.setAnimationState("movement", "idle")
  end

  if stateData.wanderMovementTimer <= 0 then
    stateData.movement = 0
  end

  if self.idleSoundTimer <= 0 then
    entity.playSound(entity.randomizeParameter("idleNoise"))
    self.idleSoundTimer = entity.randomizeParameterRange("idleSoundTime")
  end

  stateData.wanderTimer = stateData.wanderTimer - dt
  stateData.wanderMovementTimer = stateData.wanderMovementTimer - dt
  stateData.wanderFlipTimer = stateData.wanderFlipTimer - dt

  return false
end