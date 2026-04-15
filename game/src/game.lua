Game = Object:extend();
require "src/camera"
require "src/world"
function Game:new()
	self.camera = Camera();
	self.world = World();
end

local packformat = "snn"


function Game:serialize()
	return love.data.pack("string", packformat, self.world:serialize(),self.camera.x, self.camera.y);
end

--- Deserializes game data and restores the game state.
--- @param data string The serialized game data to deserialize
--- @return nil
function Game:deserialize(data)
	local packedWorld, cameraX, cameraY = love.data.unpack(packformat, data)
	self.world = World()
	self.world:deserialize(packedWorld)
	self.camera.x = cameraX
	self.camera.y = cameraY
end

function Game:initalize()
	
	
	self.world.chunks[1] = Chunk()
	
	for i = 1, 32*32, 1 do
		--restrict to a 10x10 area for testing
		if ((i - 1) % 32 < 16) and (math.floor((i - 1) / 32) < 16) then
			self.world.chunks[1].tiles[i] = Tile()
			self.world.chunks[1].tiles[i].id = 1
		end
	end

end


local oldMouse1Down = false
local oldMouse2Down = false
function Game:update(dt)
	local mouseDown1 = love.mouse.isDown(1)
	local mouseDown2 = love.mouse.isDown(2)
	local mouse1Pressed = mouseDown1 and not oldMouse1Down
	local mouse2Pressed = mouseDown2 and not oldMouse2Down

	local worldMouseX, worldMouseY = love.mouse.getPosition()
	worldMouseX = worldMouseX + self.camera.x
	worldMouseY = worldMouseY + self.camera.y

	worldMouseX = math.floor((worldMouseX - 7) / 36)
	worldMouseY = math.floor((worldMouseY - 7) / 36)

	local chunkX = math.floor(worldMouseX / 32)
	local chunkY = math.floor(worldMouseY / 32)
	local chunkIndex = Utils.coordToSpiralIndex(chunkX, chunkY)

	local tilex = worldMouseX % 32
	local tiley = worldMouseY % 32

	if(mouseDown1) then
		local tile = Tile()
		tile.id = 11
		self.world:setTileAt(worldMouseX, worldMouseY, tile)
	end
	if(mouse2Pressed) then
		if(self.world:getTileAt(worldMouseX, worldMouseY).id ~= 12) then
			local tile = Tile()
			tile.id = 12
			self.world:setTileAt(worldMouseX, worldMouseY, tile)
		else
			local tile = self.world:getTileAt(worldMouseX, worldMouseY)
			tile.direction = (tile.direction + 1) % 4
		end
		
	end

	local rl = (love.keyboard.isDown("a") and 1 or 0) - (love.keyboard.isDown("d") and 1 or 0)
	local ud = (love.keyboard.isDown("w") and 1 or 0) - (love.keyboard.isDown("s") and 1 or 0)
	self.camera:move(-200 * dt * rl, -200 * dt * ud)
	if love.keyboard.isDown("space") then
		local file = love.filesystem.newFile("saves/debug.vdat", "w")
		file:open("w")
		local save = Save.fromGame(self)
		save:saveToFile(file)
		file:close()
	end
	
	oldMouse1Down = mouseDown1
	oldMouse2Down = mouseDown2

	self.world:update(dt)

end

function Game:draw()
	love.graphics.push()
	love.graphics.translate(-self.camera.x, -self.camera.y)
	

	

	local width, height = love.graphics.getDimensions()
	Rendering.rightEdge = width / 2 + self.camera.x + 25 -- right edge of screen in world coordinates
	Rendering.topEdge = height / 2 + self.camera.y + 25 -- top edge of screen in world coordinates
	Rendering.leftEdge = self.camera.x - width / 2 - 25
	Rendering.bottomEdge = self.camera.y - height / 2 - 25
	Rendering.atlasSpriteBatch:clear()


	love.graphics.setColor(1, 1, 1);
	self.world:render()
	love.graphics.draw(Rendering.atlasSpriteBatch)

	local x, y = love.mouse.getPosition()
	local selectorx = math.floor((x + self.camera.x - 7) / 36) * 36 + 7
	local selectory = math.floor((y + self.camera.y - 7) / 36) * 36 + 7
	for i = 12, 12, 1 do
		local offsetx = i % 5 - 2
		local offsety = math.floor(i / 5) - 2
		love.graphics.draw(Resources.atlas, Resources.quads["selector"], selectorx + offsetx * 36, selectory + offsety * 36, 0, 3, 3)
	end
	love.graphics.pop()
end

function Game:reset()
	print("Game reset!")
end


