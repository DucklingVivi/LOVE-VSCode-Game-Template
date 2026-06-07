require "src.signal.signal"

AutomationSignal = Signal:extend()






function AutomationSignal:new(automation)

end


function AutomationSignal:__tostring()
	return "AutomationSignal"
end
