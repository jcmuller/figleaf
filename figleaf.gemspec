require File.expand_path("../lib/figleaf/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Juan C. Müller"]
  gem.email = ["jcmuller@gmail.com"]
  gem.description = "YAML based DRY settings manager."
  gem.summary = "YAML based DRY settings manager."
  gem.homepage = "http://github.com/jcmuller/figleaf"

  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.name = "figleaf"
  gem.require_paths = ["lib"]
  gem.version = Figleaf::VERSION

  gem.add_dependency "activesupport", ">= 3"
  gem.add_dependency "hashie", ">= 2"
end
