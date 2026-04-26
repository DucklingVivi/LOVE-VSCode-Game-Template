local rotatable = {}

rotatable.id = "rotatable"

rotatable.key_pressed_over = function(self, world, x, y, keys)
	if keys["e"] or keys["q"] then
		self.destroy(self, x, y, world)
		local dir = 0
		dir = dir - (keys["e"] and 1 or 0)
		dir = dir + (keys["q"] and 1 or 0)
		self.direction = (self.direction + 3 + dir) % 4 + 1
		world:setTileAt(x, y, self)
	end
end

return rotatable
