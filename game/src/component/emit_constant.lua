return function(value)
	local to_emit = Component("emit_constant_signal")
	return {
		to_emit = function(tile)
			return value
		end
	}
end

