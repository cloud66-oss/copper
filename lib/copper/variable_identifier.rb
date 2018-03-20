module Copper
	class VariableIdentifier < CopperNode

	def value(vars = {})
		variables = vars[:variables] || {}
		identifier = self.text_value.to_sym
		if variables.has_key?(identifier)
			return variables[identifier]
		else
			raise ::Copper::ParseError, "no variable found with name #{identifier}"
		end
	end

	end
end
