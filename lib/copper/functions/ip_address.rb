require 'ipaddress'

module Copper
  module Functions
	class IPAddress < CopperNode

		include ::Copper::ExpressionUtils

		def value(vars = {})
			ipaddress = elements[0].value(vars)
			result = ::IPAddress.parse(ipaddress)

			return handle_attributes(result, vars)
		end

	end
  end
end
