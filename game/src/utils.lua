local utils = {}

function utils.getIdxFromCoord(x,y)
	
	local chunkidx = Utils.coordToSpiralIndex(math.floor(x / 32), math.floor(y / 32))
	local tileid = x % 32 + (y % 32) * 32 + 1
	return chunkidx, tileid
end


function utils.getCoordFromIdx(chunkidx, tileid)
	local chunkx, chunky = Utils.spiralIndexToCoord(chunkidx)
	local tilex = (tileid - 1) % 32
	local tiley = math.floor((tileid - 1) / 32)
	return chunkx * 32 + tilex, chunky * 32 + tiley
end

function utils.calculateLaserValue(tilex, tiley, direction)
	local chunk, index = Utils.getIdxFromCoord(tilex, tiley)
	local laserindex = (chunk * 32*32 + index) * 4 + direction - 1
	return laserindex
end

function utils.unpackLaserValue(laserindex)
	local direction = laserindex % 4 + 1
	local chunkindex = math.floor(laserindex / (32*32*4))
	local tileindex = math.floor((laserindex % (32*32*4)) / 4)
	local tilex, tiley = Utils.getCoordFromIdx(chunkindex, tileindex)
	return tilex, tiley, direction
end

function utils.spiralIndexToCoord(index)
	if index == 1 then
		return 0, 0
	end
	local M = math.ceil((math.sqrt(index) - 1) / 2)
	local base = (2 * M - 1) ^ 2
	local side = 2 * M
	local offset = index - base - 1
	local sideIndex = math.floor(offset / side)
	local positionIndex = offset % side
	if sideIndex == 0 then
		return M, -M + positionIndex + 1
	elseif sideIndex == 1 then
		return M - positionIndex - 1, M
	elseif sideIndex == 2 then
		return -M, M - positionIndex - 1
	else
		return -M + positionIndex + 1, -M
	end
end

function utils.coordToSpiralIndex(x,y)
	local M = math.max(math.abs(x), math.abs(y))
	if M == 0 then
		return 1
	end
	local base = (2 * M - 1) ^ 2
	local side = 2 * M
	if x == M and y > -M then
		return base + (y + M)
	elseif y == M then
		return base + side + (M - x)
	elseif x == -M then
		return base + 2 * side + (M - y)
	else
		return base + 3 * side + (x + M)
	end
end

return utils
