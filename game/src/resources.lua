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
	["automaton"] = love.graphics.newImage("assets/automaton.png"),
	["multitile"] = love.graphics.newImage("assets/multitile.png")
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
local replace_temp = {"serialize", "deserialize", "update", "create", 
"get_update_phases", "neighbor_update",
"laser_enter", "laser_update", "laser_clean", 
"clean", "dirty", "destroy", "key_pressed_over", "draw_over",
 "receive_signal", "to_emit", "receive_connection", "send_connection"}
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
	get_update_phases = function(comps,v)
		return function(self)
			local retval = {}
			for _, comp in pairs(comps) do
				local result = comp[v](self)
				for _, value in ipairs(result or {}) do
					retval[value] = true
				end
			end
			return retval
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
		phases = {},
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
		build = function(self)
			
			for _, v in pairs(replace_temp) do
				for _, component in pairs(self.components) do
					if component[v] then
						table.insert(self["funcs_"..v], component)
					end
				end
				self[v] = nil
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



--Load tiles from external file
require("src.resources.tiles")(resources, new_tile)



return resources
