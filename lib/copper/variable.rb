module Copper
	class Variable < CopperNode
		include ::Copper::ExpressionUtils

		def value(vars = {})
			return handle_attributes(elements[0].value(vars), vars)
		end
	end
end
