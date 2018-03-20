module Copper
	# Node class for a simple string.
	class String < CopperNode

		include ::Copper::ExpressionUtils

		def value(vars = {})
			return handle_attributes(elements[0].value(vars), vars)
		end
	end

	class StringContent < CopperNode
		def value(vars = {})
			return text_value
		end
	end
end
