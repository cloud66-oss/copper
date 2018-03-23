module Copper
	class Set < CopperNode

		include ::Copper::ExpressionUtils

		def value(vars = {})
			result = elements[0].value(vars)
			if result.is_a?(::Array)
				v = result
			else
				v = [result]
			end
			return handle_attributes(v, vars)
		end

	end
end
