function init(args)
  entity.setInteractive(true)
end

function onInteraction(args)
local RandomNumber =math.random(5)

	if RandomNumber <= 1 then
		entity.setAnimation(draw1)
	elseif <=2 then
		entity.setAnimation(draw2)
	elseif <=3 then
		entity.setAnimation(draw3)
	elseif <=4 then
		entity.setAnimation(draw4)
	else
		entity.setAnimation(draw5)
end

function hasCapability(capability)
  return false
end
