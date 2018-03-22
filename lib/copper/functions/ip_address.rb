require 'ipaddress'

module Copper
  module Functions
	class IPAddress < CopperNode

		include ::Copper::ExpressionUtils

		def value(vars = {})
			ipaddress = elements[0].value(vars)
			result = ::IPAddress.parse(ipaddress)

			return handle_attributes(result, vars)
		rescue ArgumentError => exc
			raise RuntimeError, exc.message
		end

	end
  end
end
