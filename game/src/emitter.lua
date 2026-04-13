


return function(direction, value)
	local emitter = {}


	emitter.id = "emitter"

	emitter.direction = direction
	emitter.value = value


	emitter.update = function(self, dt, world, chunk, index)
		if world.laserManager:laserAt(chunk, index, self.direction) then
			world.laserManager:setLaserValue(chunk, index, self.direction, self.value)
		else
			world.laserManager:addLaser(chunk, index, self.direction, self.value, 48)
		end
	end

	emitter.create = function(self)
		self.direction = emitter.direction
		self.value = emitter.value
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
