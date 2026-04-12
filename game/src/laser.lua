Laser = Object:extend()

function Laser:new(origin,value,strength)
	self.value = value
	self.path = {}
	self.origin = origin
	self.dirty = true
	self.strength = strength
end

local chunkSize = 32*32

local dmove = {-1, 32, 1, -32}
---@param chunk number
---@param tile number
---@param direction number
--- @return number chunk, number tile
local function moveLaser(chunk, tile, direction)
	local tomove = dmove[direction]
	local tilemove = tile + tomove
	
	local modulo = 32 * (((direction - 1) % 2 * 31) + 1)
	
	local wrapped = ((tilemove - 1) % modulo) - ((tile - 1) % modulo) ~= tomove



	local newtile = tilemove
	local newchunk = chunk;
	if(wrapped) then
		local x, y = World.spiralIndexToCoord(chunk)
		if direction == 1 then
			x = x - 1
			newtile = tile + 31
		elseif direction == 2 then
			y = y + 1
			newtile = tile - 32*31
		elseif direction == 3 then
			x = x + 1
			newtile = tile - 31
		else
			y = y - 1
			newtile = tile + 32*31
		end
		newchunk = World.coordToSpiralIndex(x, y)
	end

	return newchunk, newtile

end

function Laser:buildPath(world)
	self.path = {}
	table.insert(self.path, self.origin)
	local current = self.origin
	local chunk = math.floor(current / 4 / chunkSize)
	local temp1 = current % (chunkSize * 4)
	local index = math.floor(temp1 / 4)
	local direction = temp1 % 4 + 1


	
	while self.strength > 0 do
		chunk, index = moveLaser(chunk, index, direction)
		--debug 
		if not world.chunks[chunk] then
			world.chunks[chunk] = Chunk()
		end
		world.chunks[chunk].tiles[index] = Tile()
		world.chunks[chunk].tiles[index].id = 4
		self.strength = self.strength - 1
	end

	
	
end

function Laser:setValue(value)
	self.value = value
end
