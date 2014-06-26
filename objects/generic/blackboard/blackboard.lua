function init(args)
  entity.setInteractive(true)
end

function onInteraction(args)
local RandomNumber =math.random(5)

	if RandomNumber <= 1 then
		entity.setAnimationState("drawState", "draw1")
	elseif RandomNumber<=2 then
		entity.setAnimationState("drawState", "draw2")
	elseif RandomNumber<=3 then
		entity.setAnimationState("drawState", "draw1")
	elseif RandomNumber<=4 then
		entity.setAnimationState("drawState", "draw1")
	else
		entity.setAnimationState("drawState", "draw2")
	end
end
