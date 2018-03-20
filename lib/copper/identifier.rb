module Copper
	# Node class for an identifier
	class Identifier < CopperNode

		def value(vars = {})
			return self.text_value.to_sym
		end
	end
end
