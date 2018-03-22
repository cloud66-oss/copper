module Copper
	module DataTypes
		class String < DataType

			def count
				return @value.size
			end

			def gsub(pattern, replacement)
				return @value.gsub(pattern, replacement)
			end

			def split(separator)
				return @value.split(separator)
			end

			def at(index)
				if index >= @value.size
					raise ParseError, "index #{index} out of bound [0..#{@result.size - 1}]"
				else
					return @value[index]
				end
			end

		end
	end
end
