module Copper
	class Symbol < CopperNode
		def value(vars = {})
			return text_value[1..-1]
		end
	end
end
