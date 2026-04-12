Tile = Object:extend()

function Tile:new()
	self.id = 0
end

function Tile:update(dt, world, chunk, index)
	local resource = Resources.tiles[self.id]
	if resource and resource.update then
		resource.update(self, dt, world, chunk, index)
	end
end

function Tile:serialize()
	local data = bit.bor(self.id, (self:hasExtraData() and 0b10000000 or 0))
	local serializedTile = love.data.pack("string", "B", data)
	if self:hasExtraData() then
		serializedTile = serializedTile .. love.data.pack("string", "s", self:serializeExtraData())
	end
	local resource = Resources.tiles[self.id]
	if resource and resource.serialize then 
		serializedTile = serializedTile .. love.data.pack("string", "s", resource.serialize(self))
	end
	return serializedTile
end

function Tile:serializeExtraData()
	return "extra data"
end

function Tile:deserialize(packedTile)
	local dataByte, byteIndex = love.data.unpack("B", packedTile)
	--- @cast dataByte number
	--- @cast byteIndex number
	local hasExtraData = bit.band(dataByte, 0b10000000) ~= 0
	self.id = bit.band(dataByte, 0b01111111)
	if hasExtraData then
		local extraData, newidx = love.data.unpack("s", packedTile, byteIndex)
		byteIndex = newidx
	end
	--- @cast byteIndex number
	local resource = Resources.tiles[self.id]
	if resource and resource.deserialize then
		local serializedTile = love.data.unpack("s", packedTile, byteIndex)
		resource.deserialize(self, serializedTile)
	end
end

function Tile:hasExtraData()
	return false
end

function Tile:getColor()
	return Resources.tiles[self.id]:color()
end

function Tile:getQuad()
	return Resources.quads[Resources.tiles[self.id].texture]
end

function Tile:create()
	local resource = Resources.tiles[self.id]
	if resource and resource.create then
		resource.create(self)
	end
end

function Tile:render(x, y)
	if Resources.tiles[self.id] then
		Rendering.atlasSpriteBatch:setColor(self:getColor())
		Rendering.atlasSpriteBatch:add(self:getQuad(), x + 25, y + 25, 0,3,3)
	end
end
