function init(args)

local RandomNumber =math.random(100)
				
				if RandomNumber <= 33.3 then
				entity.setAnimationState("switchState", "off")
				
				
				elseif RandomNumber<=66.7 then
				entity.setAnimationState("switchState", "on")
				
				else
				
				entity.setAnimationState("switchState", "test")
				
				
				end
end