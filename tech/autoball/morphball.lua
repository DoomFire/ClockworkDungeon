function init()
  data.specialLast = false
  data.primaryFireLast = false
  data.angularVelocity = 0
  data.angle = 0
  data.active = false
  tech.setVisible(false)
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
  elseif data.active and args.moves["primaryFire"] and not data.primaryFireLast then
    move = "morphballBomb"
  end

  data.specialLast = args.moves["special"] == 1
  data.primaryFireLast = args.moves["primaryFire"]

  return move
end

function update(args)
  local energyCostPerSecond = tech.parameter("energyCostPerSecond")
  local ballCustomMovementParameters = tech.parameter("ballCustomMovementParameters")
  local ballTransformHeightChange = tech.parameter("ballTransformHeightChange")
  local ballDeactivateCollisionTest = tech.parameter("ballDeactivateCollisionTest")
  local ballRadius = tech.parameter("ballRadius")
  local ballFrames = tech.parameter("ballFrames")
  local ballBombProjectile = tech.parameter("ballBombProjectile")

  if not data.active and args.actions["morphballActivate"] then
    tech.setVisible(true)
    tech.burstParticleEmitter("morphballActivateParticles")
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
      tech.setVisible(false)
      tech.burstParticleEmitter("morphballDeactivateParticles")
      tech.translate({0, -ballTransformHeightChange})
      tech.setParentAppearance("normal")
      tech.setToolUsageSuppressed(false)
      data.angle = 0
      data.active = false
    else
      -- Make some kind of error noise if not auto-deactivating
    end
  end

  if data.active then
    tech.applyMovementParameters(ballCustomMovementParameters)

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

    if args.actions["morphballBomb"] and ballBombProjectile then
      world.spawnProjectile(ballBombProjectile, tech.position(), tech.parentEntityId())
    end

    return energyCostPerSecond * args.dt
  end

  return 0
end
