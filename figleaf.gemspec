# -*- encoding: utf-8 -*-
require File.expand_path('../lib/figleaf/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Juan C. Müller"]
  gem.email         = ["jcmuller@gmail.com"]
  gem.description   = %q{YAML based DRY settings manager.}
  gem.summary       = %q{YAML based DRY settings manager.}
  gem.homepage      = "http://github.com/challengepost/figleaf"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "figleaf"
  gem.require_paths = ["lib"]
  gem.version       = Figleaf::VERSION

  gem.add_dependency "activesupport", ">= 4"
  gem.add_dependency "hashie", ">= 2"
end
