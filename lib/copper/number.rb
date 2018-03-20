module Copper
	# Node class for a simple number.
	class Number < CopperNode

		def value(vars = {})
			return text_value.to_i
		end

	end
end
