local font = {}




function font:ofSize(size)
	if(self[size]) then
		return self[size]
	end
	local newFont = love.graphics.newFont("assets/ComicSansMS.ttf", size)
	self[size] = newFont
	return newFont
end




return font
