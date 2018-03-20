module Copper
	module ExpressionUtils

		def handle_attributes(parent, vars)
			tail = elements.last
			return parent if tail.nil? || !tail.is_a?(::Copper::Attributes)

			# run the tail
			return tail.value(parent, vars)
		end

	end
end
