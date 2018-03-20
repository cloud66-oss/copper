module Copper
	class Range < CopperNode

		include ::Copper::ExpressionUtils

		def value(vars = {})
			lhs = elements[0].value(vars)
			rhs = elements[1].value(vars)

			return handle_attributes((lhs..rhs), vars)
		rescue ArgumentError => exc
			raise RuntimeError, "#{lhs} (#{lhs.class.name})..#{rhs} (#{rhs.class.name}) #{exc.message}"
		end
	end
end
