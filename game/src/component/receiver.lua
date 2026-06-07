local receiver = Component("receiver")


receiver.laser_clean = function(tile)
	tile.received_value = nil
end

receiver.laser_enter = function(tile, world, laser, segment)
	laser:addEndpoint(world, segment)
	tile.received_value = laser.value
end

receiver.laser_update = function(tile, laser)
	local laser_value = laser.value
	tile.received_value = laser_value
end


return receiver
