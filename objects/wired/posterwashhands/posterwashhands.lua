if entity.direction()==1 then
if RandomNumber <= 33.3 then
entity.setAnimationState("switchState", "poster1");

elseif RandomNumber<=66.7 then
entity.setAnimationState("switchState", "poster2");
entity.FrameState=2;
else

entity.setAnimationState("switchState", "poster3");
entity.FrameState=3;
end 
elseif entity.direction()==-1 then
if RandomNumber <= 33.3 then
entity.setAnimationState("switchState", "Lposter1");

elseif RandomNumber<=66.7 then
entity.setAnimationState("switchState", "Lposter2");
entity.FrameState=2;
else

entity.setAnimationState("switchState", "Lposter3");
entity.FrameState=3;
end 
