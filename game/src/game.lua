Game = Object:extend();
require "src/camera"
require "src/resources"
require "src/world"
function Game:new()
	self.camera = Camera();
	self.world = World();
end

local packformat = "ss"


function Game:serialize()
	return love.data.pack("string", packformat, "egg", self.world:serialize());
end

--- Deserializes game data and restores the game state.
--- @param data string The serialized game data to deserialize
--- @return nil
function Game:deserialize(data)
	local unpackedData, packedWorld = love.data.unpack(packformat, data)
	self.world = World()
	self.world:deserialize(packedWorld)
end

function Game:initalize()
	
	for i = 1, 10, 1 do
		for j = 1, 10, 1 do
			print(World.coordToSpiralIndex(i-5, j-5))
		end
	end
	self.world.chunks[1] = Chunk()
	
	for i = 1, 32*32, 1 do
		self.world.chunks[1].tiles[i].enabled = true
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

	worldMouseX = math.floor((worldMouseX - 25) / 36)
	worldMouseY = math.floor((worldMouseY - 25) / 36)

	local chunkX = math.floor(worldMouseX / 32)
	local chunkY = math.floor(worldMouseY / 32)
	local chunkIndex = World.coordToSpiralIndex(chunkX, chunkY)

	local tilex = worldMouseX % 32
	local tiley = worldMouseY % 32

	if(mouseDown1) then
		if(not self.world.chunks[chunkIndex]) then
			self.world.chunks[chunkIndex] = Chunk()
		end
		self.world.chunks[chunkIndex].tiles[tilex + tiley * 32 + 1].enabled = true
	end
	if(mouseDown2) then
		if(not self.world.chunks[chunkIndex]) then
			self.world.chunks[chunkIndex] = Chunk()
		end
		self.world.chunks[chunkIndex].tiles[tilex + tiley * 32 + 1].enabled = false
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
	if love.keyboard.isDown("c") then
		print(self.world.chunks[1].tiles[1].enabled)
	end
	oldMouse1Down = mouseDown1
	oldMouse2Down = mouseDown2
end

function Game:draw()
	love.graphics.push()
	love.graphics.translate(-self.camera.x, -self.camera.y)

	love.graphics.setColor(1, 0, 1);
	--love.graphics.line(30, 0, 30, 1000);
	love.graphics.setColor(1, 1, 1);

	Rendering.atlasSpriteBatch:clear()

	local width, height = love.graphics.getDimensions()
	--get onscreen chunks

	local rightEdge = width / 2 + self.camera.x + 25 -- right edge of screen in world coordinates
	local topEdge = height / 2 + self.camera.y + 25 -- top edge of screen in world coordinates

	local rightMostChunk = math.ceil(rightEdge / (32 * 36))
	local topMostChunk = math.floor(topEdge / (32 * 36))

	local leftEdge = self.camera.x - width / 2 - 25
	local bottomEdge = self.camera.y - height / 2 - 25

	local leftMostChunk = math.floor(leftEdge / (32 * 36))
	local bottomMostChunk = math.ceil(bottomEdge / (32 * 36))

	
	for i = leftMostChunk - 1, rightMostChunk + 1, 1 do
		for j = topMostChunk - 1, bottomMostChunk + 1, 1 do
			local chunkIndex = World.coordToSpiralIndex(i, j)
			local chunk = self.world.chunks[chunkIndex]
			local chunkX = i * 32 * 36
			local chunkY = j * 32 * 36
			if chunk then
				for index, value in ipairs(chunk.tiles) do
					local x = (index - 1) % 32
					local y = math.floor((index - 1) / 32)
					if value.enabled then
						Rendering.atlasSpriteBatch:add(Resources.quads["Debug4"], chunkX + 25 + x * 36, chunkY + 25 + y * 36, 0,3,3)
					end
				end
			end
		end
	end

	love.graphics.draw(Rendering.atlasSpriteBatch)

	local x, y = love.mouse.getPosition()
	local selectorx = math.floor((x + self.camera.x - 25) / 36) * 36 + 25
	local selectory = math.floor((y + self.camera.y - 25) / 36) * 36 + 25
	for i = 0, 24, 1 do
		local offsetx = i % 5 - 2
		local offsety = math.floor(i / 5) - 2
		love.graphics.draw(Resources.atlas, Resources.quads["selector"], selectorx + offsetx * 36, selectory + offsety * 36, 0, 3, 3)
	end
	love.graphics.pop()
end

function Game:reset()
	print("Game reset!")
end


