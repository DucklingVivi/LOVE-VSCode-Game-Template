local multitile = Component("multitile")

multitile.create = function(tile)
	tile.multitile_tiles = {}
	tile.multitile_phases = {}
	for i = 0, 4, 1 do
		tile.multitile_tiles[i] = Tile()
	end

	tile:dirty()

	--DEV STUFF
	tile.multitile_tiles[1] = Tile(16)
	tile.multitile_tiles[1].direction = 1
	tile.multitile_tiles[1]:create();

	tile.multitile_tiles[2] = Tile(16)
	tile.multitile_tiles[2].direction = 2
	tile.multitile_tiles[2]:create();
	

	tile.multitile_tiles[0] = Tile(16)
	tile.multitile_tiles[0].direction = 0
	tile.multitile_tiles[0]:create();

	tile.multitile_tiles[3] = Tile(11)
	tile.multitile_tiles[3].direction = 3
	tile.multitile_tiles[3]:create();

	--tile.multitile_tiles[4] = Tile(17)
	--tile.multitile_tiles[4]:create();
end




multitile.serialize = function(tile)
	local packedData = ""
	for i = 0, 4, 1 do
		packedData = packedData .. love.data.pack("string","s", tile.multitile_tiles[i]:serialize())
	end
	return packedData
end

multitile.clean = function(tile)
	local phases = multitile.get_update_phases(tile)
	for _, phase in pairs(phases) do
		tile.multitile_phases[phase] = {}
	end
	for i = 0, 4, 1 do
		phases = tile.multitile_tiles[i]:get_update_phases()
		print("phases for tile " .. i)
		for k, _ in pairs(phases or {}) do
			table.insert(tile.multitile_phases[k] or {}, i)
		end
	end
	for key, value in pairs(tile.multitile_phases) do
		for _, t in pairs(value) do
			print(key, t)
		end
	end
end

multitile.deserialize = function(tile, packedData)
	local index = 1
	tile.multitile_tiles = {}
	tile.multitile_phases = {}

	for i = 0, 4, 1 do
		local tileData, newindex = love.data.unpack("s", packedData, index)
		---@cast tileData string
		---@cast newindex number
		index = newindex
		local newTile = Tile()
		newTile:deserialize(tileData)
		tile.multitile_tiles[i] = newTile
	end
	tile:dirty()
end

multitile.get_update_phases = function(tile)
	return {"pre", "update" ,"post"}
end

multitile.update = function(tile, phase, world, tilex, tiley)
	local toupdate = tile.multitile_phases[phase]
	for _, t in pairs(toupdate or {}) do
		tile.multitile_tiles[t]:update(phase, world, tilex, tiley)
	end
end

multitile.destroy = function(tile, x, y, world)
	for _, t in pairs(tile.multitile_tiles) do
		t:destroy(x, y, world)
	end
end

multitile.receive_connection = function(tile, visited, world, tileX, tileY, direction)
	for _, t in pairs(tile.multitile_tiles) do
		if(t.receive_connection) then
			t:receive_connection(visited, world, tileX, tileY, direction)
		end
	end
end

multitile.send_connection = function(tile, visited, world, tileX, tileY)
	for _, t in pairs(tile.multitile_tiles) do
		if(t.send_connection) then
			t:send_connection(visited, world, tileX, tileY)
		end
	end
end

multitile.laser_update = function(tile, dt, world, tilex, tiley)
	for _, t in pairs(tile.multitile_tiles) do
		if t:getResource() and t:getResource().laser_update then
			t:getResource().laser_update(t, dt, world, tilex, tiley)
		end
	end
end

multitile.laser_enter = function(tile, world, tilex, tiley, direction)
	for _, t in pairs(tile.multitile_tiles) do
		if t:getResource() and t:getResource().laser_enter then
			t:getResource().laser_enter(t, world, tilex, tiley, direction)
		end
	end
end

local mapx = {-1, 0, 1, 0,0}
local mapy = {0, 1, 0, -1,0}
multitile.draw_over = function(tile, x, y)

	for i, t in pairs(tile.multitile_tiles) do
		local tileX = mapx[i + 1] * 12 
		local tileY = mapy[i + 1] * 12
		if t:getResource() then
			Rendering.atlasSpriteBatch:setColor(t:getColor())
			Rendering.atlasSpriteBatch:add(t:getQuad(), x + 25 + tileX, y + 25 + tileY, math.pi * (2 - (t.direction + 1) / 2),1,1, 6,6)
			t:render(x + tileX * 36, y + tileY * 36)
		end
	end
end



return multitile
