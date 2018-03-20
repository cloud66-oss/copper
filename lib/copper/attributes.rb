module Copper

	class Attributes < CopperNode

		# parent is the object attributes work on
		# like "abc".map(xxx).count : abc (string) is parent for gsub and array from map is the parent for count
		def value(parent, vars = {})
			# this has all the attributes as an array. they will be [attribute, attributes]
			# attributes will then be [attribute and attributes] and so on

			current_obj = elements[0].value(parent, vars)
			# no right association, so we are the last attribute
			return current_obj if elements[1].nil?

			# has right association, which means we need to get the value of the current attribute and pass into the
			# next one
			return elements[1].value(current_obj, vars)
		end

	end
end
