function init(args)
	entity.setInteractive(true)
    entity.setAnimationState("beaconState", "idle")
	 self.spawnDelay = -1
	 self.spawnCooldown =-1
end

function onInboundNodeChange(args)
	if self.spawnCooldown==0 then
	--entity.smash()
	self.spawnDelay=5
    entity.setAnimationState("beaconState", "active")
    end
end

function onInteraction(args)
	
	if self.spawnDelay<0 and self.spawnCooldown==-1 then
		self.spawnDelay=5
		self.spawnCooldown=25
		entity.setAnimationState("beaconState", "active")
	else
	
	return { "ShowPopup", { message = "delay: ".. self.spawnDelay .." cooldown: " .. self.spawnCooldown } }
		
   end
   
end

function main() 

	if self.spawnDelay>0 then
			self.spawnDelay = self.spawnDelay - 1
			self.spawnCooldown=self.spawnCooldown-1
			
		if self.spawnDelay == 0 then
			
			world.spawnMonster("autoguard", entity.toAbsolutePosition({ -0.7, -1 }), { level = 1 })
			self.spawnDelay =-1
			
		end
		
	elseif self.spawnCooldown>=0 then
			self.spawnCooldown=self.spawnCooldown-1
			
			if self.spawnCooldown==-1 then
				entity.setAnimationState("beaconState", "idle")
			end
	end
end