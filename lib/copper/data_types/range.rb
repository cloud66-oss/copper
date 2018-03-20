module Copper
	module DataTypes

		class Range < DataType

			def contains(value)
				@value.include?(value)
			end

			def in(value)
				@value.include?(value)
			end

		end

	end
end
