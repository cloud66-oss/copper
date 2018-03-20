require 'jsonpath'

module Copper
  module Functions
	class Fetch < CopperNode

		include ::Copper::ExpressionUtils

		def value(vars = {})
			key = elements[0].value(vars)
			context = vars[:context]

			begin
				path = JsonPath.new(key)
				result = path.on(context)
			rescue ArgumentError => exc
				raise ParseError, "JSONPath error #{key}: #{exc.message}"
			rescue NoMethodError => exc
				raise ParseError, "JSONPath error #{key}. Invalid JSONPath"
			end

			return handle_attributes(result, vars)
		end

	end
  end
end
