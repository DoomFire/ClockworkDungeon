function init(args)
	entity.setInteractive(true)
    entity.setAnimationState("beaconState", "idle")
	 self.spawnDelay = -1
	 self.spawnCooldown =0
end

function onInboundNodeChange(args)
	if self.spawnCooldown==0 then
	--entity.smash()
	self.spawnDelay=5
    entity.setAnimationState("beaconState", "active")
    end
end

function onInteraction(args)
	if self.spawnCooldown==0 then
	--entity.smash()
	self.spawnDelay=5
    entity.setAnimationState("beaconState", "active")
   end 
-- return { "ShowPopup", { message = "a: " .. self.spawnCooldown } } (only still in here so I can remember how to debug with the popup :P )
end

function main() 
	if self.spawnCooldown==0 then
		if self.spawnDelay > 0 then
			self.spawnDelay = self.spawnDelay - 1
			if self.spawnDelay == 0 then
				world.spawnMonster("autoguard", entity.toAbsolutePosition({ -0.7, -1 }), { level = 1 })
				self.spawnDelay =-1
				self.spawnCooldown=25
			end
		end
	else 
		self.spawnCooldown=self.spawnCooldown-1
	end
end