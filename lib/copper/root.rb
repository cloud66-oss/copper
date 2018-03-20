module Copper
	class Root < CopperNode
		def value(vars = {})
			result = []
			elements.each do |element|
				parse_result = element.value(vars)
				result << parse_result unless parse_result.nil?
			end

			return result
		end
	end
end
