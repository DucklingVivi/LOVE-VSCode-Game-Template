LaserManager = Object:extend()
require "src/laser"


local function calculateLaserValue(chunk, index, direction)
	local laserindex = (chunk * 32*32 + index) * 4 + direction - 1
	return laserindex
end

function LaserManager:new()
	self.lasers = {}
	self.nextvalues = {}
end


function LaserManager:update(dt, world)
	for index, laser in pairs(self.lasers) do
		local nextvalue = self.nextvalues[index]
		if nextvalue then
			laser:setValue(nextvalue)
		end
		if laser.dirty then
			laser:buildPath(world)
			laser.dirty = false
		end
	end
	self.nextvalues = {}
end

function LaserManager:addLaser(chunk, index, direction, value, strength)
	local laserindex = calculateLaserValue(chunk, index, direction)
	self.lasers[laserindex] = Laser(laserindex, value, strength)
end

 

function LaserManager:laserAt(chunk, index, direction)
	local laserindex = calculateLaserValue(chunk, index, direction)
	return self.lasers[laserindex]
end

function LaserManager:setLaserValue(chunk, index, direction, value)
	local laserindex = calculateLaserValue(chunk, index, direction)
	self.nextvalues[laserindex] = value
end


