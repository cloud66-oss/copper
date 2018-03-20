module Copper
	class Copper
		def initialize(content, vars = {})
			@content = content
			@vars = vars

			# add the resevered ones
			@vars[:variables] = ::Copper::DataTypes::DataType::RESEVERED_TYPES
			@parser = Parser.new
		end

		def execute(options = {})
			root_node = @parser.parse(@content)
			result = root_node.value(@vars) unless root_node.nil?
			puts result if $debug

			return result
		end

		def valid?
			self.execute(@content, @vars)
			return true
		rescue CopperError
			return false
		end

		def parser
			@parser.cc_parser
		end

	end
end
