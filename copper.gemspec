
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'copper/version'

Gem::Specification.new do |spec|
  spec.name          = "copper"
  spec.version       = Copper::VERSION
  spec.authors       = ["Khash Sajadi"]
  spec.email         = ["khash@cloud66.com"]

  spec.summary       = %q{Copper gem and command line}
  spec.description   = %q{Copper is a tool to validate configuration files}
  spec.homepage      = "https://github.com/cloud66/copper"
  spec.license       = 'Nonstandard'

  spec.files         = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rerun", "~> 0.13"
  spec.add_development_dependency "byebug", "~> 10.0"

  spec.add_dependency 'jsonpath', '~>0.8'
  spec.add_dependency 'json', '~> 2.1'
  spec.add_dependency 'thor', '~> 0.20'
  spec.add_dependency 'treetop', '~> 1.6'
  spec.add_dependency 'colorize', '~> 0.8'
  spec.add_dependency 'semantic', '~> 1.6'
  spec.add_dependency 'ipaddress', '~> 0.8'
end
