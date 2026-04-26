local mirror = {}




mirror.id = "mirror"


mirror.laser_enter = function(self, world, laser, segment)
	local offset = (self.direction % 2 * 2 - 1)
	offset = offset * (segment.direction % 2 * 2 - 1)
	local newDirection = (segment.direction + 3 + offset) % 4 + 1
	segment.length = segment.length - 1
	laser:addSegment(segment.strength, newDirection, segment.tilex, segment.tiley, 0)
	laser:finishSegment(segment)
	
end


return mirror
