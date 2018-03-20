module Copper

	class Attribute < CopperNode

		# attribute takes in a parent as it always depends on another node
		# like "abc".count here count is the attribute and string (abc) is the parent
		# parent is a PORO
		def value(parent, vars = {})
			raise "invalid use of attribute" if parent.nil? # this shouldn't happen as parser will not let .count to be called without a parent

			# 0 is the name of the attribute
			attribute = elements[0].value
			# 1 is the params and is optional
			params = elements[1].value(vars) unless elements[1].nil?

			# now we should call the func based on the name of the attribute with params on parent
			# here we first convert the PORO to a DataType to make the calls safe
			dt_obj = factory(parent)
			if dt_obj.respond_to?(attribute)
				if params.nil?
					return dt_obj.send(attribute)
				else
					return dt_obj.send(attribute, *params)
				end
			else
				raise ParseError, "#{attribute} is not a valid attribute for #{dt_obj.class.name}"
			end
		end
	end
end
