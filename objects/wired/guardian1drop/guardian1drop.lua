function init(args)
	entity.setInteractive(true)
    entity.setAnimationState("beaconState", "idle")
 
end

function onInboundNodeChange(args)
	--entity.smash()
    entity.setAnimationState("beaconState", "active")
    world.spawnMonster("autoguard", entity.toAbsolutePosition({ -0.7, -0.5 }), { level = 1 })
end

function onInteraction(args)
	--entity.smash()
    entity.setAnimationState("beaconState", "active")
    world.spawnMonster("autoguard", entity.toAbsolutePosition({ -0.7, -0.5 }), { level = 1 })
end