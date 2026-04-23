Coord = Object:extend()


function Coord:new(x, y)
	self.x = x
	self.y = y
end

function Coord:unpack()
	return self.x, self.y
end
