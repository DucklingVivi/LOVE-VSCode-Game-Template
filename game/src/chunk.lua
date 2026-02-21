Chunk = Object:extend()
require "src/tile"

function Chunk:new()
	self.tiles = {} -- 32x32 array of tiles
	for i = 1, 32*32, 1 do
		self.tiles[i] = Tile()
	end
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
end
