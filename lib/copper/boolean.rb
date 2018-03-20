module Copper
	class Boolean < CopperNode

		def value(vars = {})
			return text_value == 'true'
		end

	end
end
