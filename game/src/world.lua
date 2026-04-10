World = Object:extend()
require "src/chunk"
require "src/laserManager"
local packformat = "ss"

function World:new()
	self.chunks = {} -- 2D array of chunks, integer indexed in a spiral pattern
	self.laserManager = LaserManager()
end

function World:update(dt)
	for _, chunk in pairs(self.chunks) do
		chunk:update(dt, self)
	end
	self.laserManager:update(dt, self)
end

function World.coordToSpiralIndex(x,y)
	local M = math.max(math.abs(x), math.abs(y))
	if M == 0 then
		return 1
	end
	local base = (2 * M - 1) ^ 2
	local side = 2 * M
	if x == M and y > -M then
		return base + (y + M)
	elseif y == M then
		return base + side + (M - x)
	elseif x == -M then
		return base + 2 * side + (M - y)
	else
		return base + 3 * side + (x + M)
	end
end

--- Deserializes packed data to reconstruct the World state.
--- @param packedWorld string The serialized world data to deserialize
--- @return nil
function World:deserialize(packedWorld)
	self.chunks = {}
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
		if indexDiff > 0 then
			resultformat = resultformat .. "B"
			packedData = packedData .. love.data.pack("string","B", indexDiff)
		end
		resultformat = resultformat .. "s"
		packedData = packedData .. love.data.pack("string", "s", chunk:serialize())
		currentIndex = i + 1
	end
	return love.data.pack("string",packformat,resultformat, packedData)
end

