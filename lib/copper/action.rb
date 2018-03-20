module Copper
	class Action < CopperNode

		def value(vars = {})
			return text_value.to_sym
		end

	end
end
