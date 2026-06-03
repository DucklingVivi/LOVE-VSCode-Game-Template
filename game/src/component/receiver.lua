local receiver = {}

receiver.id = "receiver"

receiver.laser_enter = function(self, world, laser, segment)
	local resource = self:getResource()
	if(resource and resource.receive_signal) then
		resource.receive_signal(self,world, laser)
	end
end
  
return receiver
