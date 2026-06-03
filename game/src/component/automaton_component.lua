local automaton = {}

require "src.automaton.automaton"
require "src.signal.signal"

automaton.id = "automaton"

automaton.to_emit = function(self)
	return Signal()
end

automaton.receive_signal = function(self, world,laser)
	self.automaton:receive_signal(laser.value)
end

automaton.update = function(self, dt, world)
	self.automaton:update(dt, world)
end

automaton.create = function(self)
	self.automaton = Automaton()
end

automaton.destroy = function(self, x, y, world)
	--print("Automaton destroy")
end

automaton.serialize = function(self)
	local serializedAutomaton = self.automaton:serialize()
	return love.data.pack("string", "s", serializedAutomaton)
end

automaton.deserialize = function(self, packedAutomaton)
	local automatonData, _ = love.data.unpack("s", packedAutomaton)
	self.automaton = Automaton()
	self.automaton:deserialize(automatonData)
end

automaton.draw_over = function(self, x, y)
	self.automaton:draw(x, y)
end

return automaton
