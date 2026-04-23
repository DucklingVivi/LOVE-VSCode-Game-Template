local solid = {}

solid.id = "solid"

solid.laser_enter = function(self, world, laser, segment)
	segment.length = segment.length - 2
	laser:finishSegment(segment)
end
  
return solid
