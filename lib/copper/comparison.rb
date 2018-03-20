module Copper
	class Comparison < CopperNode

		def value(vars = {})
			lhs = elements[0].value(vars)
			comp_op = elements[1].value(vars)
			rhs = elements[2].value(vars)

			raise ParseError, "cannot compare nil" if rhs.nil? || lhs.nil?

			begin
				case comp_op
				when '='
					return equality(lhs, rhs)
				when '=='
					return equality(lhs, rhs)
				when '>'
					return lhs > rhs
				when '<'
					return lhs < rhs
				when '<='
					return lhs <= rhs
				when '>='
					return lhs > rhs
				when '!='
					return lhs != rhs
				when 'in'
					# this depends on the types
					rhs_class = ::Copper::DataTypes::DataType.get_class(rhs.class.name)
					rhs_obj = rhs_class.new(rhs)
					if rhs_obj.respond_to?(:in)
						return rhs_obj.in(lhs)
					else
						raise ::Copper::RuntimeError, "in is not a valid comparision on #{rhs_class.name}"
					end

				when '->'
					# this is a special case to pipe lhs to console
					console(lhs)
				end
			rescue NoMethodError => exc
				raise ParseError, "comparison error: #{exc.message}"
			end
		end

		private

		def equality(lhs, rhs)
			if lhs.is_a?(Array) && rhs.is_a?(Array)
				return lhs.sort == rhs.sort
			else
				return lhs == rhs
			end
		rescue ArgumentError => exc
			raise ParseError, "equality comparison failed: #{exc.message}"
		end
	end
end
