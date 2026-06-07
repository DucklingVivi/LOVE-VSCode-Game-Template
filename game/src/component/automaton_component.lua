--- @class AutomatonComponent : Component
local automaton = Component("automaton")


require "src.automaton.automaton"
require "src.signal.automaton_signal"


automaton.to_emit = function(tile)
	return AutomationSignal(tile.automaton)
end

automaton.update_laser = function(tile, world,laser)
	tile.automaton:receive_signal(laser.value)
end

automaton.get_update_phases = function(tile)
	return {"update"}
end

automaton.update = function(tile, dt, world)
	tile.automaton:update(dt, world)
end

automaton.create = function(tile)
	tile.automaton = Automaton()
end

automaton.destroy = function(tile, x, y, world)
	--print("Automaton destroy")
end

automaton.serialize = function(tile)
	local serializedAutomaton = tile.automaton:serialize()
	return love.data.pack("string", "s", serializedAutomaton)
end

automaton.deserialize = function(tile, packedAutomaton)
	local automatonData, _ = love.data.unpack("s", packedAutomaton)
	tile.automaton = Automaton()
	tile.automaton:deserialize(automatonData)
end

automaton.draw_over = function(tile, x, y)
	tile.automaton:draw(x, y)
end

return automaton
