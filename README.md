# Settings

YAML based DRY settings manager.

The YAML expansion functionality came about by our getting tired of having to
create a YAML file and then create an initializer that would expand such file
and include in our applications.

## Installation

Add this line to your application's Gemfile:

    gem 'settings'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install settings

## Usage

In `application.rb`:

```
Settings.configure_with_auto_define do |s|
  s.env = Rails.env
  s.some_awesome_flag = true
  s.load_settings
end
```
Then, you can override any particular setting inside your environments/*.rb
files.

eg: In `production.rb`
```
Settings.configure do |s|
  s.some_awesome_flag = false
end
```
etc...

Also, it provides the ability for you to define all your environment dependent
settings in just one YAML file inside `config/settings/`. The anatomy of these
files should be:

```
development:
  foo: bar

test:
  foo: flob

production:
  foo: foo
```

The Settings parser will create a namespace for your YAML file after the file
name.

Then, assuming that you named your YAML file `mysetting.yml`. you can just
access `foo` as `Settings.mysetting["foo"]`. (Inspired by Rails' `database.yml`,
of course.)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
