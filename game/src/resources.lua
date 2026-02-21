local resources = {}
resources.quads = {}

local to_stitch = {
	["Debug4"] = love.graphics.newImage("assets/debug4.png"),
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




return resources
