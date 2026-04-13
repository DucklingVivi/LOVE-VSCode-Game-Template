World = Object:extend()
require "src/chunk"
require "src/laserManager"
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

function World:update(dt)
	for k, chunk in pairs(self.chunks) do
		chunk:update(dt, self, k)
	end
	self.laserManager:update(dt, self)
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

