function init()
	data.specialLast = false
	data.jumpLast = false
	data.active = false
	tech.setVisible(true)
	data.superJumpTimer = 0
	data.hoverTimer = 0
	data.animationDelay = 0.5

	
	data.deactivating=false
	data.jumping = false
	data.hovering = false
  
	ui.init()

end

function uninit()
  if data.active then
    tech.setVisible(false)
    data.active = false
  end
end

function input(args)

	ui.input(args)

	
	local move = nil

	if args.moves["special"] == 1 and args.moves["down"] and  data.active then
		world.logInfo("test")
		
	elseif args.moves["special"] == 1 and not data.specialLast then
    
	if data.active then
    	if  args.moves["jump"] and not tech.onGround() then
		  data.hovering = false
		end
		data.hovering = false
		return "morphballDeactivate"
	else
		data.hovering = false
      return "centurainPackActivate"
    end
	
	
	elseif data.active then
	
		if  args.moves["jump"] and not tech.onGround() and data.hoverTimer <= 0 then
			data.hoverTimer = 0.1
			data.hovering = true	
		elseif  args.moves["jump"] and data.hovering and data.hoverTimer <= 0 then
			 data.hoverTimer = 0.1
			 data.hovering = false
		end
		
		if args.moves["up"] and not tech.onGround() then
		  return "superjump"			
		end

end
 
  data.specialLast = args.moves["special"] == 1
  data.jumpLast = args.moves["jump"]
  
  return move
end

function update(args)

	if not data.active then
    tech.setAnimationState("morphball", "nonDefault")
	end

	ui.update(args)
	
	if data.hoverTimer > 0 then
	  data.hoverTimer = data.hoverTimer - args.dt
	  end
	
  local energyCostPerSecond = tech.parameter("energyCostPerSecond")
  
			if  data.hovering then
				tech.yControl(0, 600, true)
				tech.applyMovementParameters({gravityEnabled = false})
			else
				tech.applyMovementParameters({gravityEnabled = true})
			end
  
  
  
  if not data.active and args.actions["centurainPackActivate"] then
    tech.setAnimationState("morphball", "activate")
	
   data.active = true
  elseif data.active and (args.actions["morphballDeactivate"]) then
	  tech.setAnimationState("morphball", "deactivate")
	  data.deactivating=true
  end

  

  if data.active then

  
  
-- 	  if we have to turn off, then count down the timer
	if data.deactivating then
	  if data.animationDelay <= 0 then
      data.active = false
	  data.animationDelay = 0.5
	  data.deactivating=false
	  else
	  data.animationDelay = data.animationDelay - args.dt
	  end
    end	
	
	-- Super Jump
  local energyUsage = tech.parameter("energyUsage")
  local superJumpSpeed = tech.parameter("superjumpSpeed")
  local superJumpControlForce = tech.parameter("superjumpControlForce")
  local superJumpTime = tech.parameter("superjumpTime")
  local superjumpSound = tech.parameter("superjumpSound")

  local usedEnergy = 0

  if args.actions["superjump"] then
    tech.jump(true)
  end
  
  if usedEnergy ~= 0 then
    return usedEnergy
  end
  
    return energyCostPerSecond * args.dt
  end

  return 0
end















--------------------------------------------------------------------------------------
-- UI Library -- DO NOT CHANGE THIS LINE OR ANY LINE BELOW IT -- 0.1b ---------------
--------------------------------------------------------------------------------------

ui = {
  groups = {},
  rootGroups = {},
  components = {}
}

-- Initialize UI - MUST CALL IN TECH INIT()
function ui.init()
  local rootGroups = tech.animationStateProperty("uiRootGroups", "groups")
  --world.logInfo("Root Groups: %s", rootGroups)
  ui.loadGroups(rootGroups)
  ui.switchToGroup(nil)
  --world.logInfo("UI Groups: ")
  --printTable(ui.groups, 0)
end

-- Update UI input - MUST CALL IN TECH INPUT() WITH INPUT ARGS
function ui.input(args)
  if args.moves["primaryFire"] == true then
    ui.mouseDown = true
  else
    if ui.mouseDown == true then
      ui.mouseOff = true
    else
      ui.mouseOff = false
    end
    ui.mouseDown = false
  end
end

-- Update UI - MUST CALL IN TECH UPDATE() WITH UPDATE ARGS
function ui.update(args)
  local mousePos = world.distance(args.aimPosition, tech.position())
  for compName, comp in pairs(ui.components) do
    if comp.visible == true then
      comp:update(mousePos)
    end
  end
end

-- Get a group by name
function ui.getGroup(groupName)
  return ui.groups[groupName]
end

-- Get a component by name
function ui.getComponent(componentName)
  return ui.components[componentName]
end

-- Sets only this group to be visible
function ui.switchToGroup(groupName)
  for _,group in pairs(ui.rootGroups) do
    group:setVisible(false)
  end
  if groupName ~= nil then
    ui.groups[groupName]:setVisible(true)
  end
end

function ui.loadGroups(groups, parent)
  local groupsOut = {}
  --world.logInfo("Loading groups: %s", groups)
  for _,groupName in ipairs(groups) do
    --world.logInfo("Loading group: %s", groupName)
    local subGroupNames = tech.animationStateProperty(groupName, "subGroups")
    --world.logInfo("Loading subGroups: %s", subGroupNames)
    local group = Group:new({
      name = groupName,
      parent = parent
    })

    local subGroups = ui.loadGroups(subGroupNames, group)

    group.subGroups = subGroups

    local components = {}
    local componentNames = tech.animationStateProperty(groupName, "components")
    --world.logInfo("Loading components: %s", componentNames)
    for _,componentName in ipairs(componentNames) do
      --world.logInfo("Loading component: %s", componentName)
      local componentInfo = tech.animationStateProperty(componentName, "uiInfo")
      local comp = Component:new({
        name = componentName,
        parent = group,
        offset = componentInfo.offset or {0, 0},
        takesInput = componentInfo.takesInput or false,
        customPoly = componentInfo.customPoly or false,
        polygon = componentInfo.polygon or {},
        min = {100, 100},
        max = {-100, -100},
        visible = tech.animationState(componentName) ~= "invisible"
      })
      comp:reload()
      if comp.takesInput then
        comp.hoverFunction = componentInfo.hoverFunction
        comp.pressFunction = componentInfo.pressFunction
      end
      ui.components[componentName] = comp
      components[#components + 1] = comp
      --world.logInfo("Loaded component: %s", componentName)
    end

    group.components = components
    groupsOut[#groups + 1] = group
    ui.groups[groupName] = group
    if parent == nil then
      ui.rootGroups[groupName] = group
    end
    --world.logInfo("Loaded group: %s", groupName)
  end
  --world.logInfo("Loaded groups: %s", groups)
  return groupsOut
end

Group = {
  name = "default",
  parent = nil,
  subGroups = {},
  components = {}
}

function Group:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- Sets visibliity of a group
function Group:setVisible(visible)
  for _,subGroup in ipairs(self.subGroups) do
    subGroup:setVisible(visible)
  end
  for _,component in ipairs(self.components) do
    component:setVisible(visible)
  end
end

Component = {
  name = "default",
  visible = false,
  parent = nil,
  takesInput = false,
  hovering = false,
  pressed = false,
  min = {0, 0},
  max = {0, 0},
  offset = {0, 0},
  customPoly = false,
  polygon = {}
}

function Component:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- Sets visibility of component
function Component:setVisible(visible)
  if visible ~= self.visible then
    self.visible = visible
    if not visible then
      if self.hoverFunction ~= nil and self.hoverFunction ~= "" and self.hovering then
        _ENV[self.hoverFunction](false, self.name)
      end
      self.hovering = false
      self.pressed = false
    end
    --world.logInfo("Setting %s visible %s", self.name, visible and "normal" or "invisible")
    self:setAnimationState(visible and "normal" or "invisible")
    --world.logInfo("Animation state of %s: %s", self.name, tech.animationState(self.name))
  end
end

function Component:reload()
  local componentInfo = tech.animationStateProperty(self.name, "uiInfo")
  if componentInfo ~= nil then
    self.offset = componentInfo.offset or self.offset
    self.customPoly = componentInfo.customPoly or false
    self.polygon = componentInfo.polygon or {}
    if self.customPoly == true then
      for _,point in ipairs(self.polygon) do
        point[1] = point[1] + self.offset[1]
        if point[1] < self.min[1] then
          self.min[1] = point[1]
        end
        if point[1] > self.max[1] then
          self.max[1] = point[1]
        end
        point[2] = point[2] + self.offset[2]
        if point[2] < self.min[2] then
          self.min[2] = point[2]
        end
        if point[2] > self.max[2] then
          self.max[2] = point[2]
        end
      end
    else
      self.min[1] = self.offset[1]
      self.min[2] = self.offset[2]
      self.max[1] = self.offset[1] + componentInfo.size[1]
      self.max[2] = self.offset[2] + componentInfo.size[2]
      -- world.logInfo("%s min: %s, max: %s", self.name, self.min, self.max)
    end
  end
end

function Component:update(mousePos)
  if not self.takesInput then
    return
  end
  if self:contains(mousePos) then
    -- world.logInfo("%s contains mouse at %s", self.name, mousePos)
    if ui.mouseOff and self.pressed then
      if self.pressFunction ~= nil and self.pressFunction ~= "" then 
        _ENV[self.pressFunction](self.name)
      end
    end
    if not self.visible then
      return
    end
    if ui.mouseDown and not self.pressed then
      self:setAnimationState("pressed")
      self.pressed = true
    elseif (not self.hovering) or (not ui.mouseDown and self.pressed) then
      self:setAnimationState("hover")
      self.pressed = false
    end
    if self.hoverFunction ~= nil and self.hoverFunction ~= "" and not self.hovering then
      _ENV[self.hoverFunction](true, self.name)
    end
    self.hovering = true
  else
    if self.hovering or self.pressed then
      self:setAnimationState("normal")
      if self.hoverFunction ~= nil and self.hoverFunction ~= "" then
        _ENV[self.hoverFunction](false, self.name)
      end
    end
    self.hovering = false
    self.pressed = false
  end
end

-- Sets animation state of a component
function Component:setAnimationState(animState)
  if tech.animationState(self.name) ~= animState then
    tech.setAnimationState(self.name, animState)
    self:reload()
  end
end

function Component:contains(relativePos)
  -- world.logInfo("pointer: %s compare to min: %s, max: %s (%s)", relativePos, self.min, self.max, self.name)
  if relativePos[1] >= self.min[1] and
      relativePos[1] <= self.max[1] and
      relativePos[2] >= self.min[2] and
      relativePos[2] <= self.max[2] then
    if self.customPoly == true then
      local nvert = #self.polygon
      local i = 1
      local j = nvert
      local c = false
      while i <= nvert do
        if ( ((self.polygon[i][2] > relativePos[2]) ~= (self.polygon[j][2] > relativePos[2])) and
            (relativePos[1] < (self.polygon[j][1] - self.polygon[i][1]) * (relativePos[2] - self.polygon[i][2]) / 
            (self.polygon[j][2] - self.polygon[i][2]) + self.polygon[i][1]) ) then
          c = not c
        end
        j = i
        i = i + 1
      end
      return c
    else
      return true
    end
  end
  return false
end