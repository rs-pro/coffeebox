# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/coffebox/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-coffeebox"
  spec.version       = Rails::Coffeebox::VERSION
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

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
