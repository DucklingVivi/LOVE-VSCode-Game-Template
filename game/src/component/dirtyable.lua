local dirtyable = {}

dirtyable.id = "dirtyable"

dirtyable.update = function(self, dt, world)
	if self.dirty then
		if(self.clean) then
			self.clean(self)
		end
		self.dirty = false
	end
end


return dirtyable
