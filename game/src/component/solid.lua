local solid = Component("solid")

solid.laser_enter = function(tile, world, laser, segment)
	laser:finishSegment(segment, -2)
end
  
return solid
