module Copper
	# Copper parser node with helper methods for cleaning.
	class CopperNode < Treetop::Runtime::SyntaxNode

		protected

		def console(text)
			puts "[DEBUG] #{self.class.name} ==> #{text} (#{text.class.name})" if $debug
		end

		def factory(poro)
			return ::Copper::DataTypes::DataType.factory(poro)
		end

	end
end
