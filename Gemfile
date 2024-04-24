source "https://rubygems.org"

gemspec

# This are needed here by travis-ci
group :test do
  gem "rake"
  gem "rspec"
end

group :development do
  gem "rb-fchange", require: false
  gem "rb-fsevent", require: false
  gem "rb-inotify", require: false

  gem "guard-bundler", require: false
  gem "guard-livereload", require: false
  gem "guard-rspec", require: false
  gem "libnotify", require: false # linux notifications
  gem "ruby_gntp", require: false # os x notifications
  gem "terminal-notifier-guard", require: false

  gem "pry", require: false
  gem "pry-byebug", require: false

  gem "standard", require: false
end
