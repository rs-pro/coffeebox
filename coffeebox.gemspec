# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coffeebox/version'

Gem::Specification.new do |spec|
  spec.name          = "coffeebox"
  spec.version       = Coffeebox::VERSION
  spec.authors       = ["glebtv"]
  spec.email         = ["glebtv@gmail.com"]
  spec.description   = %q{An opinionated rewrite of Facebox in coffescript bundled as a rails gem}
  spec.summary       = %q{An opinionated rewrite of Facebox in coffescript bundled as a rails gem}
  spec.homepage      = "https://github.com/rs-pro/coffeebox"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", ">= 3.2"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
