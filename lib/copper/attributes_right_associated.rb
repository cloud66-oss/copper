module Copper
	class AttributesRightAssociated < CopperNode
		def value(vars = {})
			byebug
			rhs = self.parent.elements[0].value(vars)
			lhs = self.elements[1].value(vars)

			return lhs
		end
	end
end
