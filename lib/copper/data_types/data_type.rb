module Copper
	module DataTypes
		class DataType

			CLASS_MAP = {
				"String" => "::Copper::DataTypes::String",
				"Array" => "::Copper::DataTypes::Array",
				"Semantic::Version" => "::Copper::DataTypes::Semver",
				"Semver" => "::Copper::DataTypes::Semver",
				"Range" => "::Copper::DataTypes::Range",
				"IPAddress" => "::Copper::DataTypes::IPAddress",
				"IPAddress::IPv4" => "::Copper::DataTypes::IPAddress",
				"IPAddress::IPv6" => "::Copper::DataTypes::IPAddress",
				"Copper::DataTypes::Image" => "::Copper::DataTypes::Image",
				"Image" => "::Copper::DataTypes::Image",
				"Copper::DataTypes::ImageClass" => "::Copper::DataTypes::Image",
				"Copper::DataTypes::FilenameClass" => "::Copper::DataTypes::Filename",
				"Copper::DataTypes::Filename" => "::Copper::DataTypes::Filename"
			}

			def initialize(value)
				@value = value
			end

			def value
				@value
			end

			def as(clazz)
				clazz = clazz.capitalize
				found_class = ::Copper::DataTypes::DataType.get_class(clazz)
				return found_class.new(@value).value
			end

			# returns a DataType based on the given PORO
			# this is to control the attribute exposure, better error handling, etc
			def self.factory(poro)
				poro_class = poro.class.name

				clazz = self.get_class(poro_class)
				return clazz.new(poro)
			end

			def self.get_class(class_name)
				raise RuntimeError, "unknown class #{class_name}" unless ::Copper::DataTypes::DataType::CLASS_MAP.has_key?(class_name)
				return Module.const_get(::Copper::DataTypes::DataType::CLASS_MAP[class_name])
			rescue NameError => exc
				raise ::Copper::RuntimeError, "invalid return type #{class_name}"
			end
		end
	end
end
