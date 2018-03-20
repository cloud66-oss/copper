module Copper
	class SingleVarDefinition < CopperNode
		RESERVED_VARS = [:semver, :array, :string]

		def value(vars = {})
			variables = vars[:variables] || {}

			lhr = elements[0].value(vars)
			rhs = elements[1].value(vars)

			# check for resevered words
			raise ::Copper::RuntimeError, "#{lhr} is a reserved word" if ::Copper::SingleVarDefinition::RESERVED_VARS.include?(lhr.to_sym)

			variables[lhr.to_sym] = rhs
			vars[:variables] = variables

			return nil
		end
	end
end
