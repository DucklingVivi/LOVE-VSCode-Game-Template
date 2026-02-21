Save = Object:extend()


function Save:new()
	self.filename = "debug"
	self.data = ""
end

function Save:saveToFile(file)
	file:write(love.data.compress("string", "zlib", self.data))
end

function Save:saveToGame()
	local game = Game();
	game:deserialize(self.data);
	return game
end

Save.fromFile = function(file)
	local save = Save();
	save.data = love.data.decompress("data", "zlib", file:read())
	return save;
end

Save.fromGame = function(game)
	local save = Save();
	save.data = game:serialize();
	return save;
end
