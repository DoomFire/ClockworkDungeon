function init(args)
	entity.setInteractive(true)
    entity.setAnimationState("beaconState", "idle")
 
end

function onInboundNodeChange(args)
  local npcSpecies = entity.randomizeParameter("spawner.npcSpeciesOptions")
  local npcType = entity.randomizeParameter("spawner.npcTypeOptions")
  local npcParameter = entity.randomizeParameter("spawner.npcParameterOptions")
  npcParameter.scriptConfig = { spawnedBy = entity.position() }
  world.spawnNpc(entity.toAbsolutePosition({ 0.0, 2.0 }), npcSpecies, npcType, entity.level(), 0, npcParameter);
  entity.smash()
end

function onInteraction(args)
  local npcSpecies = entity.randomizeParameter("spawner.npcSpeciesOptions")
  local npcType = entity.randomizeParameter("spawner.npcTypeOptions")
  local npcParameter = entity.randomizeParameter("spawner.npcParameterOptions")
  npcParameter.scriptConfig = { spawnedBy = entity.position() }
  world.spawnNpc(entity.toAbsolutePosition({ 0.0, 2.0 }), npcSpecies, npcType, entity.level(), 0, npcParameter);
  entity.smash()
end