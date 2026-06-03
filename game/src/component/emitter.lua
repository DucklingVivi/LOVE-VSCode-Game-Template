
require "src.signal.signal"
local emitter = {}


emitter.id = "emitter"


emitter.clean = function(self)
	self.value = self:to_emit()
end

emitter.update = function(self, dt, world, tilex, tiley)
	if world.laserManager:laserAt(tilex, tiley, self.direction + 1) then
		world.laserManager:setLaserValue(tilex, tiley, self.direction + 1, self.value)
	else
		world.laserManager:addLaser(tilex, tiley, self.direction + 1, self.value, 128, 1)
	end
end

emitter.create = function(self)
	self.dirty = true
end

emitter.destroy = function(self, x, y, world)
	world.laserManager:removeLaser(x, y, self.direction + 1)
end

emitter.serialize = function(self)
	return ""
end

emitter.deserialize = function(self, packedEmitter)
	self.dirty = true
end

return emitter
