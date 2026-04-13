LaserManager = Object:extend()
require "src/laser"




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

function LaserManager:render()
	for _, laser in pairs(self.lasers) do
		laser:render()
	end
end


function LaserManager:addLaser(chunk, index, direction, value, strength)
	local laserindex = Utils.calculateLaserValue(chunk, index, direction)
	self.lasers[laserindex] = Laser(laserindex, value, strength)
end

 

function LaserManager:laserAt(chunk, index, direction)
	local laserindex = Utils.calculateLaserValue(chunk, index, direction)
	return self.lasers[laserindex]
end

function LaserManager:setLaserValue(chunk, index, direction, value)
	local laserindex = Utils.calculateLaserValue(chunk, index, direction)
	self.nextvalues[laserindex] = value
end


