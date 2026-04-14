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
		local x, y = Utils.spiralIndexToCoord(chunk)
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
		newchunk = Utils.coordToSpiralIndex(x, y)
	end

	return newchunk, newtile

end

function Laser:buildPath(world)
	self.path = {}
	local current = self.origin
	self.chunk, self.index, self.direction = Utils.calculateLaserOrigin(current)

	local startx, starty = Utils.spiralIndexToCoord(self.chunk)
	local indexx = (self.index - 1) % 32
	local indexy = math.floor((self.index - 1) / 32)

	local worldx = (startx * 32 + indexx) * 36 + 25
	local worldy = (starty * 32 + indexy) * 36 + 25
	
	while self.strength > 0 do
		self.chunk, self.index = moveLaser(self.chunk, self.index, self.direction)
		--debug 
		local tileover = world.chunks[self.chunk].tiles[self.index]
		if tileover then
			local resource = tileover:getResource()
			if resource and resource.laser_enter then
				resource.laser_enter(tileover, self, world)
			end
		end
		if tileover and tileover.id <= 4 then
			world.chunks[self.chunk].tiles[self.index] = Tile()
			world.chunks[self.chunk].tiles[self.index].id = 4
		end
		self.strength = self.strength - 1
	end
	self:addPoint()
	print(#self.path)
	
end

function Laser:addPoint()
	table.insert(self.path, Utils.calculateLaserValue(self.chunk, self.index, self.direction))
end


function Laser:setValue(value)
	self.value = value
end


function Laser:render()
	local to_traverse = {(unpack(self.path))}

	local ochunk, oindex, direction = Utils.calculateLaserOrigin(self.origin)


	local chunkx, chunky = Utils.spiralIndexToCoord(ochunk)

	chunkx = chunkx * 32 * 36
	chunky = chunky * 32 * 36

	local tilex = (oindex - 1) % 32
	local tiley = math.floor((oindex - 1) / 32)

	local startx = chunkx + tilex * 36 + 25
	local starty = chunky + tiley * 36 + 25


	while #to_traverse > 0 do
		local current = table.remove(to_traverse, 1)
		local chunk, index, ndirection = Utils.calculateLaserOrigin(current)

		Rendering.atlasSpriteBatch:add(Resources.quads["laser"],startx,starty, math.pi * direction / 2,2,2, 1.5,0)
	end
	
end


