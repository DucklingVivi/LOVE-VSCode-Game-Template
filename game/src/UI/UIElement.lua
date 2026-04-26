UIElement = Object:extend()

function UIElement:new()
	self.children = {}
	self.constraints = {}
end

function UIElement:addConstraint(constraint)
	table.insert(self.constraints, constraint)
end

function UIElement:addChild(child)
	table.insert(self.children, child)
end

function UIElement:update(dt, game)
	 for _, child in pairs(self.children) do
		child:update(dt, game)
	end
end

function UIElement:draw()
	 for _, child in pairs(self.children) do
		child:draw()
	end
end

function UIElement:recalculate()
	for _, child in pairs(self.children) do
		child:recalculate()
	end
end
