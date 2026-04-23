local receiver = {}

receiver.id = "receiver"

receiver.laser_enter = function(self, world, laser, segment)
	print("Receiver hit")
end
  
return receiver
