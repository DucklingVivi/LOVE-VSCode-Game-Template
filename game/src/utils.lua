local utils = {}

--- Converts world coordinates to chunk index and tile ID.
--- @param x number World X coordinate
--- @param y number World Y coordinate
--- @return number chunkidx The chunk index
--- @return number tileid The tile ID within the chunk
function utils.getIdxFromCoord(x,y)
	
	local chunkidx = utils.coordToSpiralIndex(math.floor(x / 32), math.floor(y / 32))
	local tileid = x % 32 + (y % 32) * 32 + 1
	return chunkidx, tileid
end

--- Converts chunk index and tile ID back to world coordinates.
--- @param chunkidx number The chunk index
--- @param tileid number The tile ID within the chunk
--- @return number x World X coordinate
--- @return number y World Y coordinate
function utils.getCoordFromIdx(chunkidx, tileid)
	local chunkx, chunky = utils.spiralIndexToCoord(chunkidx)
	local tilex = (tileid - 1) % 32
	local tiley = math.floor((tileid - 1) / 32)
	return chunkx * 32 + tilex, chunky * 32 + tiley
end


function utils.packCoord(tilex, tiley)
	local chunk, index = utils.getIdxFromCoord(tilex, tiley)
	return index + chunk * 32*32
end

function utils.unpackCoord(packed)
	local chunk = math.floor(packed / (32*32))
	local index = packed % (32*32)
	return utils.getCoordFromIdx(chunk, index)
end


--- Calculates a laser value from tile coordinates and direction.
--- @param tilex number Tile X coordinate
--- @param tiley number Tile Y coordinate
--- @param direction number Direction value
--- @return number laserindex The calculated laser index
function utils.calculateLaserValue(tilex, tiley, direction)
	local chunk, index = utils.getIdxFromCoord(tilex, tiley)
	local laserindex = (chunk * 32*32 + index) * 4 + direction
	return laserindex
end

--- Unpacks a laser value back into tile coordinates and direction.
--- @param laserindex number The laser index to unpack
--- @return number tilex Tile X coordinate
--- @return number tiley Tile Y coordinate
--- @return number direction Direction value
function utils.unpackLaserValue(laserindex)
	local direction = laserindex % 4 + 1
	local chunkindex = math.floor(laserindex / (32*32*4))
	local tileindex = math.floor((laserindex % (32*32*4)) / 4)
	local tilex, tiley = utils.getCoordFromIdx(chunkindex, tileindex)
	return tilex, tiley, direction
end

--- Converts a spiral index to chunk coordinates.
--- @param index number The spiral index
--- @return number x Chunk X coordinate
--- @return number y Chunk Y coordinate
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


--- Converts chunk coordinates to a spiral index.
--- @param x number Chunk X coordinate
--- @param y number Chunk Y coordinate
--- @return number index The spiral index
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
