module Copper
	class VarDefinition < CopperNode
		def value(vars = {})
			elements.each do |element|
				element.value(vars)
			end

			return nil
		end
	end
end
