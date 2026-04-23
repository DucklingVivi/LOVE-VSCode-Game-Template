LaserManager = Object:extend()
require "src/laser"




function LaserManager:new()
	self.laserchunks = {}
	self.lasers = {}
	self.nextvalues = {}
end

function LaserManager:addLaserToChunk(chunk, laser)
	if not self.laserchunks[chunk] then
		self.laserchunks[chunk] = {}
	end
	table.insert(self.laserchunks[chunk], laser)
end

function LaserManager:updateChunkLasers(chunk)
	local lasers = self.laserchunks[chunk]
	if lasers then
		for _, laser in pairs(lasers) do
			laser.dirty = true
		end
	end
end

function LaserManager:update(dt, world)
	for index, laser in pairs(self.lasers) do
		local nextvalue = self.nextvalues[index]
		if nextvalue then
			laser:setValue(nextvalue)
		end
		if laser.dirty then
			laser:buildSegments(world)
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


function LaserManager:addLaser(tilex, tiley, direction, value, strength, slength)
	local laserindex = Utils.calculateLaserValue(tilex, tiley, direction)
	self.lasers[laserindex] = Laser(laserindex, value, strength, slength)
end

function LaserManager:removeLaser(tilex, tiley, direction)
	local laserindex = Utils.calculateLaserValue(tilex, tiley, direction)
	self.lasers[laserindex] = nil
end

function LaserManager:laserAt(tilex, tiley, direction)
	local laserindex = Utils.calculateLaserValue(tilex, tiley, direction)
	return self.lasers[laserindex]
end

function LaserManager:setLaserValue(tilex, tiley, direction, value)
	local laserindex = Utils.calculateLaserValue(tilex, tiley, direction)
	self.nextvalues[laserindex] = value
end


