module Copper
	module DataTypes
		class Image < DataType

			def initialize(value)
				if value.is_a?(::String)
					@value = deconstruct_image(value)
				else
					@value = value
				end
			end

			def to_s
				@value.to_s
			end

			def registry
				@value[:registry]
			end

			def name
				@value[:name]
			end

			def tag
				@value[:tag]
			end

			def registry_url
				@value[:registry_url]
			end

			def fqin
				@value[:fqin]
			end

			private

			def deconstruct_image(source_image)
				full_image = source_image.strip
				full_name = "library/#{full_image}" unless full_image.include?('/')
				full_image = "library/#{full_image}" unless full_image.include?('/')
				full_image = "#{full_image}:latest" unless full_image.include?(':')

				# default
				proto = 'https://'
				if full_image =~ /^https/
					proto = 'https://'
					full_image = full_image.gsub(/https:\/\//, '')
				elsif full_image =~ /^http/
					proto = 'http://'
					full_image = full_image.gsub(/http:\/\//, '')
				end

				# trim / from front and back
				full_image = full_image.gsub(/^\//, '').gsub(/\/$/, '')

				# figure out registry
				if full_image =~ /^library\// || full_image.split('/').count < 3
					# its docker io
					registry = 'index.docker.io'
				else
					registry = full_image.gsub(/\/.*/, '')
				end

				# figure out image name
				full_image = full_image.gsub(/#{registry}(\/(v|V)(1|2)|)/i,'').gsub(/^\//, '').gsub(/\/$/, '')
				image_parts = full_image.split(':')
				image_name = image_parts[0]
				image_tag = image_parts[1]

				# recombine for registry
				registry_url = "#{proto}#{registry}"

				fqin = "#{registry_url}/#{full_image}"

				# return information
				return ImageClass.new({
					fqin: fqin,
					registry: registry,
					registry_url: registry_url,
					name: image_name,
					tag: image_tag
				})
			end

		end

		class ImageClass
			attr_accessor :fqin
			attr_accessor :registry
			attr_accessor :registry_url
			attr_accessor :name
			attr_accessor :tag

			def initialize(hash)
				@fqin = hash[:fqin]
				@registry = hash[:registry]
				@registry_url = hash[:registry_url]
				@name = hash[:name]
				@tag = hash[:tag]
			end

			def to_s
				"fqin:#{fqin}, registry:#{registry}, registry_url:#{registry_url}, name:#{name}, tag:#{tag}"
			end
		end
	end
end
