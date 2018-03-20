module Copper
	class AttributeParams < CopperNode

		def value(vars = {})
			return elements[0].value(vars)
		end

	end
end
