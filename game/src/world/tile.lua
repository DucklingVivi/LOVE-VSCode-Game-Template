Tile = Object:extend()

function Tile:__index(key)
	local val = rawget(self, key) or getmetatable(self)[key]
	if val then
		return val
	end
	local id = rawget(self, "id")
	local resource = Resources.tiles[id]
	return (resource and resource[key])
end

function Tile:new(id)
	self.id = id or 0
	self.direction = 0
end

function Tile:get_update_phases()
	local resource = Resources.tiles[self.id]
	if resource and resource.get_update_phases then
		return resource.get_update_phases()
	end
end

function Tile:update(phase, world, tileX, tileY)
	local resource = Resources.tiles[self.id]
	if resource and resource.update then
		resource.update(self, phase, world, tileX, tileY)
	end
end

function Tile:neighbor_update()
	local resource = Resources.tiles[self.id]
	if resource and resource.neighbor_update then
		resource.neighbor_update(self)
	end
end

function Tile:serialize()
	local directionBits = bit.lshift(bit.band(self.direction,0b00000011), 6)
	local data = bit.bor(bit.band(self.id, 0b00111111), directionBits)
	local serializedTile = love.data.pack("string", "B", data)
	local resource = Resources.tiles[self.id]
	if resource and resource.serialize then
		serializedTile = serializedTile .. love.data.pack("string", "s", resource.serialize(self))
	end
	return serializedTile
end


function Tile:deserialize(packedTile)
	local data, byteIndex = love.data.unpack("B", packedTile)
	--- @cast data number
	--- @cast byteIndex number
	self.id = bit.band(data, 0b00111111)
	self.direction = bit.rshift(bit.band(data, 0b11000000), 6)
	--- @cast byteIndex number
	local resource = Resources.tiles[self.id]
	if resource and resource.deserialize then
		local serializedTile = love.data.unpack("s", packedTile, byteIndex)
		resource.deserialize(self, serializedTile)
	end
end


function Tile:getResource()
	return Resources.tiles[self.id]
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

function Tile:destroy(x, y, world)
	local resource = Resources.tiles[self.id]
	if resource and resource.destroy then
		resource.destroy(self, x, y, world)
	end
end

function Tile:render(x, y)
	local resource = Resources.tiles[self.id]
	if resource and resource.draw_over then
		resource.draw_over(self, x, y)
	end
end
