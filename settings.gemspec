Gem::Specification.new do |s|
  s.name = "settings"
  s.version = "0.0.1"
  s.platform = Gem::Platform::RUBY
  s.summary = ""
  s.description = ""
  s.authors = ["Juan C. Muller"]
  s.email = ["jcmuller@gmail.com"]
  s.homepage = ""
  s.license = "MIT"

  s.files        = `git ls-files`.split($\) - %w(.rspec)
  s.require_path = "lib"
  s.bindir       = "bin"
  s.executables  = []

  s.test_files = Dir["spec/**/*_spec.rb"]

  s.add_development_dependency("rake")
  s.add_dependency("yaml")
end
