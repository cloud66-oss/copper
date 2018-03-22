module Copper
	module DataTypes
		class Filename < DataType

			def initialize(value)
				if value.is_a?(::String)
					@value = FilenameClass.new(value)
				else
					@value = value
				end
			end

			def path
				@value.path
			end

			def name
				@value.name
			end

			def ext
				@value.ext
			end

			def full_name
				"#{@value.path}/#{@value.name}#{@value.ext}"
			end

			def expanded_path
				@value.expanded_path
			end
		end

		class FilenameClass
			attr_accessor :ext
			attr_accessor :name
			attr_accessor :path
			attr_accessor :expanded_path

			def initialize(filename)
				@expanded_path = File.expand_path(filename)
				@ext = File.extname(filename)
				@name = File.basename(filename, @ext)
				@path = File.dirname(filename)
			end

			def to_s
				"path:#{@paht}, name:#{@name}, ext:#{@ext}"
			end
		end
	end
end
