Tile = Object:extend()

function Tile:new()
	self.enabled = false
end

function Tile:serialize()
	return love.data.pack("string","B", self.enabled and 1 or 0)
end

function Tile:deserialize(packedTile)
	local enabledByte = love.data.unpack("B", packedTile)
	self.enabled = enabledByte == 1
end
