module Copper
	class Param < CopperNode
		def value(vars = {})
			if elements[1].nil?
				# no right association
				return elements[0].value(vars)
			else
				# has right association
				return elements[1].value(vars)
			end
		end
	end
end
