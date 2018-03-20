require 'treetop'

# Load the parser from the Treetop grammar.
Treetop.load(File.join(__dir__, 'grammar', 'copper.treetop'))

require File.join(__dir__, 'data_types', 'data_type')
# Load custom Copper syntax node.
require File.join(__dir__, 'copper_node')

require File.join(__dir__, 'expression_utils')

# Load other Copper classes.
Dir.glob File.join(__dir__, '**', '*.rb'), &method(:require)
