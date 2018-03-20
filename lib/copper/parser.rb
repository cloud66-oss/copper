module Copper
	class Parser
		def initialize
			@parser = CopperParser.new
		end

		def parse(content)
			root_node = @parser.parse(content)

			# Raise any errors.
			unless root_node
				@parser.failure_reason =~ /^(Expected .+) after/m
				if $1.nil?
					puts "#{@parser.failure_reason}"
				else
					puts "#{$1.gsub("\n", '$NEWLINE')}:"
				end
				puts content.lines.to_a[@parser.failure_line - 1]
				puts "#{'~' * (@parser.failure_column - 1)}^"
				return nil
			end

			puts root_node.inspect if $parser_debug

			clean_tree(root_node)

			puts root_node.inspect if $parser_debug

			root_node
		end

		def cc_parser
			@parser
		end

		def clean_tree(root_node)
			return if(root_node.elements.nil?)
			root_node.elements.delete_if { |node| !node.is_a?(CopperNode) }
			root_node.elements.each { |node| self.clean_tree(node) }
		end
	end
end
