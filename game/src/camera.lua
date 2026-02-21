

Camera = Object:extend();

function Camera:new()
	self.x = 0
	self.y = 0
end




function Camera:setPosition(x, y)
	self.x = x
	self.y = y
end

function Camera:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

