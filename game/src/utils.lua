local utils = {}

function utils.calculateLaserValue(chunk, index, direction)
	local laserindex = (chunk * 32*32 + index) * 4 + direction - 1
	return laserindex
end

function utils.calculateLaserOrigin(laserindex)
	local temp = laserindex % (32*32*4)
	local direction = temp % 4 + 1
	local index = math.floor(temp / 4)
	local chunk = math.floor(laserindex / (32*32*4))
	return chunk, index, direction
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
