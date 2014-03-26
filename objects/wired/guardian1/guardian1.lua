
function goodReception()
  if world.underground(entity.position()) then
    return false
  end
  
  local ll = entity.toAbsolutePosition({ -4.0, 1.0 })
  local tr = entity.toAbsolutePosition({ 4.0, 32.0 })
  
  local bounds = {0, 0, 0, 0}
  bounds[1] = ll[1]
  bounds[2] = ll[2]
  bounds[3] = tr[1]
  bounds[4] = tr[2]
  
  return not world.rectCollision(bounds, true)
end

function init(args)
  entity.setInteractive(true)
  if not goodReception() then
    entity.setAnimationState("beaconState", "idle")
  else
    entity.setAnimationState("beaconState", "active")
  end
end

function onInteraction(args)
  if not goodReception() then
    entity.setAnimationState("beaconState", "idle")
    return { "ShowPopup", { message = "No signal! Please activate on planet surface." } }
  else
    entity.setAnimationState("beaconState", "active")
    world.spawnProjectile("regularexplosion2", entity.toAbsolutePosition({ 0.0, 1.0 }))
    entity.smash()
    world.spawnMonster("autoguard", entity.toAbsolutePosition({ 0.0, 1.0 }), { level = 1 })
  end
end

function onInboundNodeChange(args)

entity.smash()
    entity.setAnimationState("beaconState", "active")
    world.spawnMonster("mobby", entity.toAbsolutePosition({ -0.7, 2.0 }), { level = 1 })
end

function hasCapability(capability)
  return false
end
