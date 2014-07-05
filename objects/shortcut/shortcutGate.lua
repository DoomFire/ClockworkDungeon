function init(args)
	entity.setInteractive(true)
	self.jump=false
end
function main()
	self.testVar = world.playerQuery( entity.position(), 100)
	
	if self.jump then
	self.jump=false
	local p = entity.toAbsolutePosition({ -1.3, 1 })
	world.logInfo("x1= "..tostring(p[1]))
	world.logInfo("y1= "..tostring(p[2]))
	world.logInfo("x1= "..tostring(p[1])+40)
	world.logInfo("y1= "..tostring(p[2])+80)

    entity.setForceRegion({ p[1], p[2], p[1] + 40, p[2]+80 }, { 0, 4000 })
	end
	
end



function onInboundNodeChange(args)
  onInteraction(args)
end

function onInteraction(args)
	
self.jump=true
world.logInfo(tostring(self.testVar))
if #self.testVar>0 then
self.playerPos=world.entityPosition(self.testVar[1])
world.logInfo(tostring(self.testVar[1]))
world.logInfo(tostring(self.playerPos[1]))
world.logInfo(tostring(self.playerPos[2]))

end
world.logInfo("--------------------------------------------------")


end