
local game;
function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	Object = require "lib/classic"
	require "src/game"
	require "src/save"
	Resources = require "src/resources"
	Rendering = require "src/rendering"
	

	local saveDir = "saves"
	--Ensure the save directory exists
	love.filesystem.createDirectory(saveDir)

	local saveName = "debug"
	
	local savePath = saveDir .. "/" .. saveName .. ".vdat"
	if love.filesystem.getInfo(savePath) then
		local f = love.filesystem.newFile(savePath)
		f:open("r")
		local save = Save.fromFile(f)
		f:close()
		game = save:saveToGame()
	else
		game = Game();
		game:initalize()
	end
end

function love.update(dt)
	game:update(dt);
end

function love.draw()
	game:draw();
end



