# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Juan C. Müller"]
  gem.email         = ["jcmuller@gmail.com"]
  gem.description   = %q{YAML based DRY settings manager.}
  gem.summary       = %q{YAML based DRY settings manager.}
  gem.homepage      = "http://github.com/challengepost/settings"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "settings"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.1'

  %w(rake rspec).each do |g|
    gem.add_development_dependency(g)
  end

  gem.add_dependency("activesupport")
end
