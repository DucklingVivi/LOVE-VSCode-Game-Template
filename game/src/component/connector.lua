--- @class Connector : Component
local connector = Component("connector")


connector.receive_connection = function(tile, visited, world, tileX, tileY, direction)
	local value = Utils.packCoord(tileX, tileY)
	local flag = (tile.direction + 2) % 4 == direction
	if(not visited[value] and flag) then
		visited[value] = true
		local tile = world:getTileAt(tileX, tileY)
		if(tile.send_connection) then
			tile:send_connection(visited, world, tileX, tileY)
		end
	elseif not visited[value] then
		visited[value] = false
	end
end



local mapx = {-1, 0, 1, 0,0}
local mapy = {0, 1, 0, -1,0}
connector.send_connection = function(tile, visited, world, tileX, tileY)
	local newtile = world:getTileAt(tileX + mapx[tile.direction + 1], tileY + mapy[tile.direction + 1])
	if(newtile.receive_connection) then
		newtile:receive_connection(visited, world, tileX + mapx[tile.direction + 1], tileY + mapy[tile.direction + 1], tile.direction)
	end
end


return connector
