Laser = Object:extend()
require "src/coord"
local laserSegment = Object:extend()


local dmovetilex = {-1, 0, 1, 0}
local dmovetiley = {0, 1, 0, -1}
---@param tilex number
---@param tiley number
---@param direction number
--- @return number chunk, number tile
local function moveLaser(tilex, tiley, direction)
	tilex = tilex + dmovetilex[direction]
	tiley = tiley + dmovetiley[direction]
	return tilex, tiley
end

function laserSegment:new(strength, direction, tilex, tiley, start_length)
	self.strength = strength
	self.direction = direction
	self.origin = Coord(tilex, tiley)
	self.tilex = tilex
	self.tiley = tiley
	self.length = 0
	self.start_length = start_length or 0
	return self
end

function laserSegment:build(world, laser)
	local oldchunk = nil
	while self.strength > 0 do
		self.tilex, self.tiley = moveLaser(self.tilex, self.tiley, self.direction)
		local chunk, _ = Utils.getIdxFromCoord(self.tilex, self.tiley)
		if chunk ~= oldchunk then
			world:getLaserManager():addLaserToChunk(chunk, laser)
			oldchunk = chunk
		end
		self.length = self.length + 2
		--debug 
		local tileover = world:getTileAt(self.tilex, self.tiley)
		if tileover then
			local resource = tileover:getResource()
			if resource and resource.laser_enter then
				resource.laser_enter(tileover, world, laser, self)
			end
		end
		self.strength = self.strength - 1
	end
end

function laserSegment:unpack()
	return self.length, self.start_length, self.direction, self.origin.x, self.origin.y
end




function Laser:new(origin,value,strength, slength)
	self.value = value
	self.segments = {}
	self.segment_queue = {}
	self.endpoints = {}
	self.origin = origin
	self.dirty = true
	self.strength = strength
	self.slength = slength or 0
end





function Laser:buildSegments(world)
	self.segments = {}
	local current = self.origin
	local tilex, tiley, direction = Utils.unpackLaserValue(current)
	
	self.segment_queue = {}

	table.insert(self.segment_queue, laserSegment(self.strength, direction, tilex, tiley, self.slength))

	while #self.segment_queue > 0 do
		local current_segment = table.remove(self.segment_queue, 1)
		current_segment:build(world, self)
		table.insert(self.segments, current_segment)
	end
end


function Laser:addSegment(strength, direction, tilex, tiley, slength)
	local segment = laserSegment(strength, direction, tilex, tiley, slength)
	table.insert(self.segment_queue, segment)
	return segment
end

function Laser:finishSegment(segment)
	segment.strength = 0
	table.insert(self.segments, segment)
end


function Laser:setValue(value)
	self.value = value
end

function Laser:getColor()

	local r = 1
	local g = 1
	local b = 1

	return r, g, b
end

local dmovex = {-18, 0, 18, 0}
local dmovey = {0, 18, 0, -18}

function Laser:render()

	for _, current in pairs(self.segments) do
		local length, slength, direction, tilex, tiley = current:unpack()
		tilex = (tilex * 36) + dmovex[direction] * (1 + slength) + 25
		tiley = (tiley * 36) + dmovey[direction] * (1 + slength) + 25
		for i = slength, length do
			local r, g, b = self:getColor()
			Rendering.atlasSpriteBatch:setColor(r, g, b, 0.6)
			Rendering.atlasSpriteBatch:add(Resources.quads["laser"],tilex,tiley, math.pi * (4 - direction) / 2,2,2, 1.5,0)
			tilex = tilex + dmovex[direction]
			tiley = tiley + dmovey[direction]
		end
	end
end


