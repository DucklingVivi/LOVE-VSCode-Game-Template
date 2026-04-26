require "src.UI.UIElement"

UI_Manager = UIElement:extend()

function UI_Manager:draw()
	self.super.draw(self)
	love.graphics.setLineWidth(2)
	local font = Resources.font:ofSize(32)
	love.graphics.setFont(font)
	--love.graphics.print("Hello World", 10, 10, 0, 1, 1)
	--love.graphics.circle("line", 100, 100, 50)
end



