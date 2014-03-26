function init()
  toUse = true
  data.HeldItem = "none"
end

function init(args)
  entity.setInteractive(true)
end

function onInteraction(args)
  if not toUse then
    return { "ShowPopup", { message = "blub" } }
  else
 entity.spawnItem("organ1")
  end
end

function hasCapability(capability)
  return false
end
