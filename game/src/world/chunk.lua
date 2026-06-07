Chunk = Object:extend()
require "src.world.tile"

function Chunk:new()
	self.tiles = {} -- 32x32 array of tiles
	for i = 1, 32*32, 1 do
		self.tiles[i] = Tile()
	end
	self.toupdate = {}
	self:dirty()
end

function Chunk:dirty()
	self._dirty = true
end

function Chunk:clean()
	self.toupdate = {}
	for idx, tile in pairs(self.tiles) do
		local toupdate = tile:get_update_phases()
		for phase, _ in pairs(toupdate or {}) do
			self.toupdate[phase] = self.toupdate[phase] or {}
			table.insert(self.toupdate[phase], idx)
		end
	end
end

function Chunk:update(phase, world, cx, cy)
	if self._dirty then
		self:clean()
		self._dirty = false
	end

	local chunkx = cx * 32
	local chunky = cy * 32
	for _, value in pairs(self.toupdate[phase] or {}) do
		local x = (value - 1) % 32
		local y = math.floor((value - 1) / 32)
		
		self.tiles[value]:update(phase, world, chunkx + x, chunky + y)
	end
end

function Chunk:setTileAt(tileId, tile)
	self.tiles[tileId] = tile
end

function Chunk:updateTileAt(tileId)
	self.tiles[tileId]:neighbor_update()
end

function Chunk:serialize()
	local packedData = ""
	for i, tile in ipairs(self.tiles) do
		packedData = packedData .. love.data.pack("string", "s", tile:serialize())
	end
	return packedData
end


--- Deserializes a packed chunk into a Chunk object.
--- @param packedChunk string The packed chunk data to deserialize
--- @local index number
--- @return nil
function Chunk:deserialize(packedChunk)
	
	local index = 1
	self.tiles = {}
	for i = 1, 32*32, 1 do
		local tileData, newindex = love.data.unpack("s", packedChunk, index)
		index = newindex
		local tile = Tile()
		tile:deserialize(tileData)
		table.insert(self.tiles, tile)
	end
	self:dirty()

end

function Chunk:render(x, y)
	for index, tile in ipairs(self.tiles) do
		local tileX = (index - 1) % 32
		local tileY = math.floor((index - 1) / 32)
		if(tile:getResource()) then
			Rendering.atlasSpriteBatch:setColor(tile:getColor())
			Rendering.atlasSpriteBatch:add(tile:getQuad(), x + tileX * 36 + 25, y + tileY * 36 + 25, math.pi * (2 - (tile.direction + 1) / 2),3,3, 6,6)
			tile:render(x + tileX * 36, y + tileY * 36)
		end
	end
end

