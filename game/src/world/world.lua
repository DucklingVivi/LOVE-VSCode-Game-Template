World = Object:extend()
require "src.world.chunk"
require "src.world.laserManager"
local packformat = "ss"

local chunkmeta = {
	__index = function(t,k)
		local val = rawget(t,k)
		if(val == nil) then
			local chunk = Chunk()
			rawset(t, k, chunk)
			val = chunk
		end
		return val
	end
}

function World:new()
	self.chunks = {} -- 2D array of chunks, integer indexed in a spiral pattern
	setmetatable(self.chunks, chunkmeta)
	self.laserManager = LaserManager()
end



local update_phases = {
	pre = 1,
	update = 2,
	post = 3
}
function World:update()
	for k, _ in pairs(update_phases) do
		for idx, chunk in pairs(self.chunks) do
			local cx, cy = Utils.spiralIndexToCoord(idx)
			chunk:update(k, self, cx, cy)
		end
	end
	self.laserManager:update("post", self)
end


function World:getTileAt(x, y)
	local chunkidx, tileid = Utils.getIdxFromCoord(x,y)
	return self.chunks[chunkidx].tiles[tileid]
end

function World:setTileAt(x, y, tile)
	local chunkidx, tileid = Utils.getIdxFromCoord(x,y)
	local oldTile = self.chunks[chunkidx].tiles[tileid]
	oldTile:destroy(x,y, self)
	self.chunks[chunkidx]:setTileAt(tileid, tile)
	self.chunks[chunkidx]:dirty()
	self:updateTileAt(x, y)
	self.laserManager:updateChunkLasers(chunkidx)
end



local adjacentOffsets = {
	{dx = -1, dy = 0},
	{dx = 1, dy = 0},
	{dx = 0, dy = -1},
	{dx = 0, dy = 1}
}
function World:updateTileAt(x,y)
	for i = 1, 4, 1 do
		local offset = adjacentOffsets[i]
		local adjx = x + offset.dx
		local adjy = y + offset.dy
		local chunkidx, tileid = Utils.getIdxFromCoord(adjx, adjy)
		self.chunks[chunkidx]:updateTileAt(tileid)
	end
end

function World:getLaserManager()
	return self.laserManager
end

function World:render()

	local rightMostChunk = math.ceil(Rendering.rightEdge / (32 * 36))
	local topMostChunk = math.floor(Rendering.topEdge / (32 * 36))

	local leftMostChunk = math.floor(Rendering.leftEdge / (32 * 36))
	local bottomMostChunk = math.ceil(Rendering.bottomEdge / (32 * 36))

	
	for i = leftMostChunk - 1, rightMostChunk + 1, 1 do
		for j = topMostChunk - 1, bottomMostChunk + 1, 1 do
			local chunkIndex = Utils.coordToSpiralIndex(i, j)
			local chunk = self.chunks[chunkIndex]
			local chunkX = i * 32 * 36
			local chunkY = j * 32 * 36
			if chunk then
				chunk:render(chunkX, chunkY)
			end
		end
	end

	Rendering.atlasSpriteBatch:setColor(1, 1, 1, 1)
	self.laserManager:render()
end

--- Deserializes packed data to reconstruct the World state.
--- @param packedWorld string The serialized world data to deserialize
--- @return nil
function World:deserialize(packedWorld)

	local dataformat, packedData = love.data.unpack(packformat, packedWorld)
	--- @cast dataformat string
	---@diagnostic disable-next-line: cast-type-mismatch
	--- @cast packedData string
	local dataindex = 1
	local chunkIndex = 1
	for i = 1, #dataformat, 1 do
		local format = dataformat:sub(i,i)
		if format == "B" then
			local indexDiff, newindex = love.data.unpack("B", packedData, dataindex)
			--- @cast newindex number
			dataindex = newindex
			chunkIndex = chunkIndex + indexDiff
		elseif format == "s" then
			local chunkData, newindex = love.data.unpack("s", packedData, dataindex)
			dataindex = newindex
			local chunk = Chunk()
			chunk:deserialize(chunkData)
			table.insert(self.chunks, chunkIndex, chunk)
			chunkIndex = chunkIndex + 1
		end
	end
	
end

function World:serialize()
	
	local resultformat = ""
	local packedData = ""
	local currentIndex = 1
	for i, chunk in pairs(self.chunks) do
		local indexDiff = i - currentIndex
		while indexDiff > 0 do
			resultformat = resultformat .. "B"
			packedData = packedData .. love.data.pack("string","B", math.min(indexDiff, 255))
			indexDiff = indexDiff - 255
		end
		resultformat = resultformat .. "s"
		packedData = packedData .. love.data.pack("string", "s", chunk:serialize())
		currentIndex = i + 1
	end
	return love.data.pack("string",packformat,resultformat, packedData)
end

