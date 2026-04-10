local emitter = {}


emitter.update = function(self, dt, world, chunk, index)
	if world.laserManager:laserAt(chunk, index, self.direction) then
		world.laserManager:setLaserValue(chunk, index, self.direction, self.value)
	else
		world.laserManager:addLaser(chunk, index, self.direction, self.value)
	end
end

emitter.create = function(self)
	self.direction = 0
	self.value = 1
end

return emitter
