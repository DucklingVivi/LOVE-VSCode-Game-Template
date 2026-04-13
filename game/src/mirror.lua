local mirror = {}




mirror.id = "mirror"


mirror.laser_enter = function(self, laser, world)
	local offset = (self.direction % 2 * 2 - 1)
	offset = offset * (laser.direction % 2 * 2 - 1)
	laser.direction = (laser.direction + 3 + offset) % 4 + 1
	laser:addPoint()
end


return mirror
