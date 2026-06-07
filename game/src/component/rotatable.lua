local rotatable = Component("rotatable")

rotatable.key_pressed_over = function(tile, world, x, y, keys)
	local right = keys["e"]
	local left = keys["q"]
	if right or left then
		tile.destroy(tile, x, y, world)
		local dir = 0
		dir = dir - (right and 1 or 0)
		dir = dir + (left and 1 or 0)
		tile.direction = (tile.direction + 4 + dir) % 4
		world:setTileAt(x, y, tile)
	end
end

return rotatable
