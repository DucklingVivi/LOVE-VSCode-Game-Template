--- @class DirtyableComponent : Component
local dirtyable = Component("dirtyable")

dirtyable.get_update_phases = function(tile)
	return {"pre"}
end

dirtyable.update = function(tile, phase, world, tileX, tileY)
	if tile.dirty then
		if(tile.clean) then
			tile.clean(tile, world, tileX, tileY)
		end
		tile.dirty = false
	end
end

dirtyable.dirty = function(tile)
	tile.dirty = true
end

return dirtyable
