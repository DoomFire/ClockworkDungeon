function init(args)

	
 
	local RandomNumber =math.random(100)
					
	if entity.direction()==1 then				
			if RandomNumber <= 33.3 then
				entity.setAnimationState("switchState", "state1");
	
			elseif RandomNumber<=66.7 then
				entity.setAnimationState("switchState", "state2");
				entity.FrameState=2;
			else
			
				entity.setAnimationState("switchState", "state3");
				entity.FrameState=3;
			end 
			
	elseif entity.direction()==-1 then
			if RandomNumber <= 33.3 then
				entity.setAnimationState("switchState", "state4");
	
			elseif RandomNumber<=66.7 then
				entity.setAnimationState("switchState", "state5");
				entity.FrameState=2;
			else
			
				entity.setAnimationState("switchState", "state6");
				entity.FrameState=3;
			end 
	
	
	
	
	
	end



end

