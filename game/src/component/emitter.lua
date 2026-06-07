
require "src.signal.signal"
local emitter = Component("emitter")


emitter.clean = function(tile)
	tile.value = tile:to_emit()
	tile.laserdirty = true
end

emitter.get_update_phases = function(tile)
	return {"post"}
end


emitter.update = function(tile, phase, world, tilex, tiley)
	local laser = world.laserManager:laserAt(tilex, tiley, tile.direction)
	if laser then
		if tile.laserdirty then
			world.laserManager:setLaserValue(tilex, tiley, tile.direction, tile.value)
			tile.laserdirty = false
		end
	else
		world.laserManager:addLaser(tilex, tiley, tile.direction, tile.value, 128, 1)
	end
end

emitter.create = function(tile)
	tile:dirty()
end

emitter.destroy = function(tile, x, y, world)
	world.laserManager:removeLaser(x, y, tile.direction)
end

emitter.serialize = function(tile)
	return ""
end

emitter.deserialize = function(tile, packedEmitter)
	tile:dirty()
end

return emitter
