local multiblock_core = Component("multiblock_core")

multiblock_core.clean = function(tile, world, tileX, tileY)
	local visited = {}
	world:getTileAt(tileX, tileY):send_connection(visited, world, tileX, tileY)
	for key, value in pairs(visited) do
		print(key, value)
	end
	tile.visited = visited
end

multiblock_core.create = function(tile)
	tile:dirty()
end

multiblock_core.serialize = function(tile)
	return ""
end

multiblock_core.deserialize = function(tile, packedData)
	tile:dirty()
end

multiblock_core.draw_over = function(tile, tilex, tiley)
	for key, value in pairs(tile.visited or {}) do
		if(value) then
			local x,y = Utils.unpackCoord(key)
			love.graphics.setColor(0, 1, 0)
			love.graphics.circle("fill", x * 36 + 25, y * 36 + 25, 4)
		end
	end
end


return multiblock_core
