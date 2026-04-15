Laser = Object:extend()

local pathEntry = Object:extend()

function pathEntry:new(length, direction)
	self.length = length
	self.direction = direction
	return self
end

function pathEntry:unpack()
	return self.length, self.direction
end




function Laser:new(origin,value,strength)
	self.value = value
	self.path = {}
	self.origin = origin
	self.dirty = true
	self.strength = strength
end

local chunkSize = 32*32

local dmovex = {-1, 0, 1, 0}
local dmovey = {0, 1, 0, -1}
---@param tilex number
---@param tiley number
---@param direction number
--- @return number chunk, number tile
local function moveLaser(tilex, tiley, direction)
	tilex = tilex + dmovex[direction]
	tiley = tiley + dmovey[direction]
	return tilex, tiley
end

function Laser:buildPath(world)
	self.path = {}
	local current = self.origin
	self.tilex, self.tiley, self.direction = Utils.unpackLaserValue(current)
	self.path.origin = {
		tilex = self.tilex,
		tiley = self.tiley,
		direction = self.direction
	}
	self.length = 0

	while self.strength > 0 do
		self.tilex, self.tiley = moveLaser(self.tilex, self.tiley, self.direction)
		self.length = self.length + 1
		--debug 
		local tileover = world:getTileAt(self.tilex, self.tiley)
		if tileover then
			local resource = tileover:getResource()
			if resource and resource.laser_enter then
				resource.laser_enter(tileover, self, world)
			end
		end
		if tileover and tileover.id <= 4 then
			local tile = Tile()
			tile.id = 4
			world:setTileAt(self.tilex, self.tiley, tile)
		end
		self.strength = self.strength - 1
	end
	self:addPoint()
end

function Laser:addPoint()
	table.insert(self.path, pathEntry:new(self.length, self.direction))
	self.length = 0
end


function Laser:setValue(value)
	self.value = value
end


function Laser:render()
	local to_traverse = {(unpack(self.path))}
	local origin = self.path.origin
	local startx = origin.tilex * 36 + 18
	local starty = origin.tiley * 36 + 18

	while #to_traverse > 0 do
		local current = table.remove(to_traverse, 1)
		local length, direction = current:unpack()
		print(length, direction)
		Rendering.atlasSpriteBatch:add(Resources.quads["laser"],startx,starty, math.pi * direction / 2,2,2, 1.5,0)
	end
	
end


