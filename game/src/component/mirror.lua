local mirror = Component("mirror")


mirror.laser_enter = function(tile, world, laser, segment)
	local offset = (tile.direction % 2 * 2 - 1)
	offset = offset * (segment.direction % 2 * 2 - 1)
	local newDirection = (segment.direction + 5 + offset) % 4 + 1
	laser:addSegment(segment.strength, newDirection, segment.tilex, segment.tiley, 0)
	laser:finishSegment(segment, -1)
	
end


return mirror
