module Copper
	class ParamRightAssociated < CopperNode
		def value(vars = {})
			rhs = self.parent.elements[0].value(vars)
			lhs = self.elements[0].value(vars)

			return ([rhs] + [lhs]).flatten
		end
	end
end
