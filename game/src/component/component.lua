--- @class Component
local component = Object:extend()

function component:new(id)
	self.id = id
end

return component
