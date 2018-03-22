require 'ipaddress'

module Copper
  module Functions
	class Image < CopperNode

		include ::Copper::ExpressionUtils

		def value(vars = {})
			image = elements[0].value(vars)
			result = ::Copper::DataTypes::Image.new(image)

			return handle_attributes(result, vars)
		end

	end
  end
end
