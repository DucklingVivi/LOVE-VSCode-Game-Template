Automaton = Object:extend()


function Automaton:new()
	self.x = 0
	self.y = 0
end

function Automaton:receive_signal(value)
	print("Automaton received signal with value: " .. tostring(value))
end


function Automaton:update(dt, world)
end

function Automaton:serialize()
	return love.data.pack("string", "nn", self.x, self.y)
end

function Automaton:deserialize(data)
	local x, y, _ = love.data.unpack("nn", data)
	self.x = x
	self.y = y
end

function Automaton:draw(x, y)
	love.graphics.setColor(1, 0.5, 1)
	love.graphics.circle("line", x + 25 + self.x, y + 25 + self.y, 10)
end
