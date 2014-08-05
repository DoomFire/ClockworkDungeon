rangedAttack = {}

function rangedAttack.enter()
  if not canStartAttack() then return nil end

  return { firing = false }
end

function rangedAttack.enteringState(stateData)
  setAggressive(true, true)

  entity.setActiveSkillName(entity.configParameter("shooterSkillName"))
end

function rangedAttack.update(dt, stateData)
  if not canContinueAttack() then return true end

  entity.rotateGroup("projectileAim", 0)

  local toTargetX = self.toTarget[1]
  local toTargetY = self.toTarget[2]

  if math.abs(toTargetX) > entity.configParameter("shooterGiveUpTolerance") then
    stateData.firing = false
    return true
  end
  
  if stateData.firing and not entity.isFiring() then
    stateData.firing = false
    return true
  end

  local rotateAmount = 0
  local maxRotate = math.pi / 180 * 30;

  entity.setFacingDirection(util.toDirection(toTargetX))
  if toTargetX < 0 then
    rotateAmount = math.atan2(toTargetY,toTargetX) - math.pi
    if rotateAmount < 0 then rotateAmount = rotateAmount + 2*math.pi end

    if (rotateAmount > maxRotate and rotateAmount < math.pi) then
      return true
    elseif (rotateAmount < (2*math.pi - maxRotate) and rotateAmount > math.pi) then
      return true
    end
  elseif toTargetX > 0 then
    rotateAmount = math.atan2(-toTargetY,toTargetX)
    if (rotateAmount > maxRotate and rotateAmount < math.pi/2) then
      return true
    elseif (rotateAmount < (2*math.pi - maxRotate) and rotateAmount > (2*math.pi - math.pi/2)) then
      return true
    end
  end

  entity.rotateGroup("projectileAim", rotateAmount);
  entity.setRunning(true)
  entity.setAnimationState("movement", "idle")

  if not entity.entityInSight(self.target) then
    return true
  end

  if entity.readyToFire() and entity.entityInSight(self.target) then
    entity.startFiring(entity.staticRandomizeParameter("shooterProjectile"))
    stateData.firing = true
  end

  if entity.isFiring() then
    entity.setAnimationState("attack", "shooting")
  else
    entity.setAnimationState("attack", "idle")
  end

  local movement = calculateSeparationMovement()
  if movement ~= 0 then
    entity.setAnimationState("movement", "walk")

    if movement > 0 then
      entity.moveRight()
    else
      entity.moveLeft()
    end
  end

  entity.setFireDirection(entity.configParameter("projectileSourcePosition"), self.toTarget)

  return false
end

function rangedAttack.leavingState(stateData)
  entity.stopFiring()
  entity.rotateGroup("projectileAim", 0)
end