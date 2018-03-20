module Copper
	class Expression < CopperNode

		def value(vars = {})
			return elements[0].value(vars)
		end
	end
end
