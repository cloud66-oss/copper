require 'semantic'

module Copper
	module DataTypes
		class Semver < DataType

			def initialize(value)
				if value.is_a? ::String
					@value = ::Semantic::Version.new(value)
				elsif value.is_a? ::Semantic::Version
					@value = ::Semantic::Version.new(value.to_s)
				else
					raise ::Copper::RuntimeError, "cannot convert #{value} to Semver"
				end
			rescue ArgumentError => exc
				raise ::Copper::RuntimeError, exc.message
			end

			def major
				@value.major
			end

			def minor
				@value.minor
			end

			def patch
				@value.patch
			end

			def build
				@value.build
			end

			def pre
				@value.pre
			end

			def satisfies(condition)
				@value.satisfies?(condition)
			end

		end
	end
end
