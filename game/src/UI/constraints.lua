local constraints = {}

local Constraint = Object:extend()
function Constraint:apply(object)

end


local MinimumConstraint = Constraint:extend()
function MinimumConstraint:new(target, minimum)
    self.target = target
	self.minimum = minimum
end
function MinimumConstraint:apply(object)
	
end

constraints.MinimumConstraint = MinimumConstraint




return constraints
