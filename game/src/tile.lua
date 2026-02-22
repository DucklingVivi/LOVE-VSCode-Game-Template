Tile = Object:extend()

function Tile:new()
	self.id = 0
end

function Tile:serialize()
	local data = bit.bor(self.id, (self:hasExtraData() and 0b10000000 or 0))
	return love.data.pack("string","B", data)
end



function Tile:deserialize(packedTile)
	local dataByte, byteIndex = love.data.unpack("B", packedTile)
	--- @cast dataByte number
	--- @cast byteIndex number
	local hasExtraData = bit.band(dataByte, 0b10000000) ~= 0
	self.id = bit.band(dataByte, 0b01111111)
	if hasExtraData then
		local extraData = love.data.unpack("s", packedTile, byteIndex)
	end
end

function Tile:hasExtraData()
	return self.id > 0b00001111
end

function Tile:getColor()
	return 1,1,1,1
end

function Tile:getQuad()
	return Resources.quads["Debug4"]
end

function Tile:render(x, y)
	if self.id > 0 then
		Rendering.atlasSpriteBatch:setColor(self:getColor())
		Rendering.atlasSpriteBatch:add(self:getQuad(), x + 25, y + 25, 0,3,3)
	end
end
