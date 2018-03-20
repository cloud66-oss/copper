module Copper
	class RuleDefinition < CopperNode

		def value(vars = {})
			rules = vars[:rules] || []
			t = {}
			t[:name] = elements[0].value(vars)

			raise ParseError, "a rule named #{t[:name]} already exists" if rules.detect { |x| x[:name] == t[:name] }

			t[:outcome] = elements[2].value(vars)
			t[:action] = elements[1].value(vars)

			rules << t
			vars[:rules] = rules

			return t
		end

	end
end
