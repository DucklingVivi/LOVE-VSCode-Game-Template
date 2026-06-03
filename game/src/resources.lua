local resources = {}
resources.quads = {}
resources.components = require("src.resources.components")
resources.font = require("src.resources.font")
local to_stitch = {
	["Debug4"] = love.graphics.newImage("assets/debug4.png"),
	["emitter"] = love.graphics.newImage("assets/debug_emitter.png"),
	["selector"] = love.graphics.newImage("assets/selector.png"),
	["mirror"] = love.graphics.newImage("assets/mirror.png"),
	["laser"] = love.graphics.newImage("assets/laser.png"),
	["automaton"] = love.graphics.newImage("assets/automaton.png")
}

local padding = 1
local padding_per_texture = padding * 2
local max_texture_size = 256






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

-- Temporary table to hold method names for replacement after finish is called
local replace_temp = {"serialize", "deserialize", "update", "create", "laser_enter", "destroy", "key_pressed_over", "draw_over", "receive_signal", "to_emit", "clean"}
local mapper = {
	to_emit = function(funcs,v)
		return function(...)
			local signals = {}
			for f, comp in pairs(funcs) do
				signals[f] = comp[v](...)
			end
			return signals[next(signals)] --Discard all but 1
		end
	end,
	serialize = function(comps,v)
		return function(self)
			local packedData = ""
			local count = 0
			for _, comp in pairs(comps) do
				count = count + 1
				packedData = packedData .. love.data.pack("string", "ss", comp.id, comp[v](self))
			end
			return love.data.pack("string", "B", count) .. packedData
		end
	end,
	deserialize = function(comps,v)

		return function(self, packedData)
			local number, index = love.data.unpack("B", packedData)
			--- @cast number number
			--- @cast index number
			local values = {}
			for i = 1, number, 1 do
				local key, data, new_index = love.data.unpack("ss", packedData, index)
				--- @cast data string
				--- @cast new_index number
				index = new_index
				values[key] = data
			end
			for _, comp in pairs(comps) do
				comp[v](self, values[comp.id])
			end
		end
	end,
	default = function(comps,v)
		return function(...)
			for _, comp in pairs(comps) do
				comp[v](...)
			end
		 end
	end
}
setmetatable(mapper, {
	__index = function(t, k)
		return rawget(t, k) or t.default
	end
})

resources.tiles = {}
local function new_tile(id, texture)
		local ret = {
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
		with_component = function(self, component)
			table.insert(self.components, component)
			return self
		end,
		has_extra_data = function(self)
			for _, component in pairs(self.components) do
				if component:hasExtraData() then
					return true
				end
			end
			return false
		end,
		finish = function(self)
			
			for _, v in pairs(replace_temp) do
				for _, component in pairs(self.components) do
					if component[v] then
						table.insert(self["funcs_"..v], component)
					end
				end
				self[v] = nil
				if self["t"..v] ~= nil then
					table.insert(self["funcs_"..v], self)
					self["t"..v] = nil
				end
				local count = 0
				for _, _ in pairs(self["funcs_"..v]) do
					count = count + 1
				end
				if count > 0 then
					self[v] = mapper[v](self["funcs_"..v],v)
				end
			end
			
			self.color = function(s)
				return s.r, s.g, s.b, s.a
			end
			resources.tiles[self.id] = self
			return self
		end
	}
	for _, v in pairs(replace_temp) do
		ret[v] = function(self, func)
			self["t"..v] = func
			return self
		end
		ret["funcs_"..v] = {}
	end
	return ret
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


-- Emitter
new_tile(11,"emitter")
:color(.5,1,0)
:with_component(resources.components.emitter)
:with_component(resources.components.rotatable)
:finish()


-- Mirror
new_tile(12,"mirror")
:color(0.85,0.85,1)
:with_component(resources.components.mirror)
:with_component(resources.components.rotatable)
:finish()



-- Receiver
new_tile(13,"emitter")
:color(0,1,1)
:with_component(resources.components.solid)
:with_component(resources.components.receiver)
:with_component(resources.components.rotatable)
:finish()

new_tile(14,"automaton")
:color(1,0.5,1)
:with_component(resources.components.dirtyable)
:with_component(resources.components.automaton)
:with_component(resources.components.solid)
:with_component(resources.components.receiver)
:with_component(resources.components.rotatable)
:with_component(resources.components.emitter)
:finish()

return resources
