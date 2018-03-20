module Copper
	class LogicRightAssociated < CopperNode
		def value(vars = {})
			rhs = self.parent.elements[0].value(vars)
			op = self.elements[0].value(vars)
			lhs = self.elements[1].value(vars)

			case op
			when 'and', '&', '&&'
				return (lhs and rhs)
			when 'or', '|', '||'
				return (lhs or rhs)
			end
		end
	end
end
