# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hubspotter/version'

Gem::Specification.new do |spec|
  spec.name          = "hubspotter"
  spec.version       = Hubspotter::VERSION
  spec.authors       = ["Table XI"]
  spec.email         = ["support@tablexi.com"]
  spec.summary       = %q{HubSpot API integration.}
  spec.description   = %q{Integrate HubSpot API support into your application.}
  spec.homepage      = "https://github.com/tablexi/hubspotter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end