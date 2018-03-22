require 'ipaddress'

module Copper
  module Functions
	class Semver < CopperNode

		include ::Copper::ExpressionUtils

		def value(vars = {})
			semver = elements[0].value(vars)
			result = ::Semantic::Version.new(semver)

			return handle_attributes(result, vars)
		end

	end
  end
end
