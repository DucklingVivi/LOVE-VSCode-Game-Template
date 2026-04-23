local rotatable = {}

rotatable.id = "rotatable"

rotatable.key_pressed_over = function(self, world, x, y, keys)
	if keys["e"] then
		self.direction = (self.direction + 1) % 4
		world:setTileAt(x, y, self)
	end
end

return rotatable
