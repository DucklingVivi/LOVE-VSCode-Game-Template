local resources = {}
resources.quads = {}

local to_stitch = {
	["Debug4"] = love.graphics.newImage("assets/debug4.png"),
	["emitter"] = love.graphics.newImage("assets/debug_emitter.png"),
	["selector"] = love.graphics.newImage("assets/selector.png")
}

local texture_size = 12
local padding = 1
local padding_per_texture = padding * 2
local max_texture_size = 256

local max_textures_per_row = math.floor(max_texture_size / (texture_size + padding_per_texture))


local stitch_atlas = function()
	local atlas = love.graphics.newCanvas(max_texture_size, max_texture_size)
	local x, y = 0, 0
	love.graphics.setBlendMode("replace")
	love.graphics.setCanvas(atlas)
	for key, value in pairs(to_stitch) do
		if(x + value:getWidth() > atlas:getWidth()) then
			x = 0
			y = y + value:getHeight() + padding_per_texture
		end
		for i = 0, 3, 1 do
			love.graphics.draw(value, x + i % 2, y + math.floor(i/2))
		end
		love.graphics.draw(value, x + padding, y + padding)
		
		resources.quads[key] = love.graphics.newQuad(x + padding, y + padding, value:getWidth(), value:getHeight(), atlas:getDimensions())
		x = x + value:getWidth() + padding_per_texture
	end
	to_stitch = nil
	love.graphics.setCanvas()
	love.graphics.setBlendMode("alpha")
	return atlas
end

--- Initializes the game's texture atlas by stitching together multiple texture resources.
--- The stitched atlas is stored in the resources.atlas field for efficient texture management and rendering.
--- @see stitch_atlas
--- @type love.Canvas
resources.atlas = stitch_atlas();


resources.tiles = {}
local function new_tile(id, texture)
	-- Temporary table to hold method names for replacement after finish is called
	local replace_temp = {"serialize", "deserialize", "update", "create"}
	return {
		id = id,
		texture = texture,
		r = 1,
		g = 1,
		b = 1,
		a = 1,
		components = {},
		color = function(self, r, g, b, a)
			self.r = r
			self.g = g
			self.b = b
			self.a = a or 1
			return self
		end,
		serialize = function(self, func)
			self.tserialize = func
			return self
		end,
		deserialize = function(self, func)
			self.tdeserialize = func
			return self
		end,
		with_component = function(self, component)
			table.insert(self.components, component)
			return self
		end,
		update = function(self, func)
			self.tupdate = func
			return self
		end,
		create = function(self, func)
			self.tcreate = func
			return self
		end,
		finish = function(self)
			
			for _, v in pairs(replace_temp) do
				self[v] = nil
				if self["t"..v] ~= nil then
					self[v] = self["t"..v]
					self["t"..v] = nil
				end
			end
			
			self.color = function(s)
				return s.r, s.g, s.b, s.a
			end
			resources.tiles[self.id] = self
			return self
		end
	}

end



new_tile(1,"Debug4"):finish()
new_tile(2,"Debug4"):color(1,0,0):finish()
new_tile(3,"Debug4"):color(0,1,0):finish()
new_tile(4,"Debug4"):color(0,0,1):finish()
new_tile(5,"Debug4"):color(1,1,0):finish()
new_tile(6,"Debug4"):color(1,0,1):finish()
new_tile(7,"Debug4"):color(0,1,1):finish()
new_tile(8,"Debug4"):color(0.5,0.5,0.5):finish()
new_tile(9,"Debug4"):color(1,0.5,0):finish()
new_tile(10,"Debug4"):color(0.5,1,0):finish()

local emitter = require("src/emitter")
new_tile(11,"emitter")
:color(.5,1,.5)
:serialize(emitter.serialize)
:deserialize(emitter.deserialize)
:create(emitter.create)
:update(emitter.update)
:finish()

new_tile(12,"mirror")
:color(1,1,1)
:serialize(function(self)
	return love.data.pack("string", "B", self.direction)
end)
:deserialize(function(self, packedData)
	local direction, _ = love.data.unpack("B", packedData)
	self.direction = direction
end)
:create(function(self)
	self.direction = 0
end)


return resources
