module Copper
  module Functions
	class Filename < CopperNode

		include ::Copper::ExpressionUtils

		def value(vars = {})
			filename = vars[:filename]
			result = ::Copper::DataTypes::Filename.new(filename)

			return handle_attributes(result, vars)
		end

	end
  end
end
