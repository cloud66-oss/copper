module Copper
	module DataTypes
		class Array < DataType

			def count
				return @value.size
			end

			def first
				return nil if @value.empty?
				return @value.first
			end

			def last
				return nil if @value.empty?
				return @value.last
			end

			def in(value)
				@value.include?(value)
			end

			# get item at index
			def at(index)
				if index >= @value.size
					raise RuntimeError, "index #{index} out of bound [0..#{@result.size - 1}]"
				else
					return @value[index]
				end
			end

			# map the items into the given class
			def as(clazz)
				clazz = clazz.capitalize
				found_class = ::Copper::DataTypes::DataType.get_class(clazz)
				return @value.map { |x| found_class.new(x).value }
			end

			def extract(regex, index)
				result = []
				@value.each do |v|
					raise RuntimeError, "#{v} is not a String" unless v.is_a?(::String)
					found = v.match(regex)
					result << nil if found.nil?
					result << nil if found[index].nil?
					result << found[index]
				end

				return result
			end

			def pick(attribute)
				return @value.map do |x|
					if x.respond_to?(attribute.to_sym)
						x.send(attribute.to_sym)
					else
						raise ParseError, "#{attribute} is not a valid attribute on #{x.class.name}"
					end
				end
			end

			def unique
				@value.uniq
			end

			def contains(item)
				@value.include?(item)
			end

		end
	end
end
