


return function(value)
	local emitter = {}


	emitter.id = "emitter"

	emitter.value = value


	emitter.update = function(self, dt, world, tilex, tiley)
		if world.laserManager:laserAt(tilex, tiley, self.direction) then
			world.laserManager:setLaserValue(tilex, tiley, self.direction, self.value)
		else
			world.laserManager:addLaser(tilex, tiley, self.direction, self.value, 128, 1)
		end
	end

	emitter.create = function(self)
		self.direction = 0
		self.value = emitter.value
	end

	emitter.destroy = function(self, x, y, world)
		world.laserManager:removeLaser(x, y, self.direction)
	end

	emitter.serialize = function(self)
		return love.data.pack("string", "B", self.direction)
	end

	emitter.deserialize = function(self, packedEmitter)
		local direction, _ = love.data.unpack("B", packedEmitter)
		self.direction = direction
	end

	return emitter
end
