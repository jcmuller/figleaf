# Figleaf
[![Build Status](https://secure.travis-ci.org/challengepost/figleaf.png?branch=master)](http://travis-ci.org/challengepost/figleaf)

YAML based DRY settings manager.

The YAML expansion functionality came about by our getting tired of having to
create a YAML file and then create an initializer that would expand such file
and include in our applications.

`Figleaf::Settings` can be used to override settings depending on what
environment your application is running. If it's a Rails app, it will know it
from `Rails.env`, otherwise it will check for `ENV['ENVIRONMENT']`.

## Installation

Add this line to your application's Gemfile:

    gem 'figleaf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install figleaf

## Usage

In `application.rb`:

```
Figleaf::Settings.configure_with_auto_define do |s|
  s.env = Rails.env
  s.some_awesome_flag = true
  s.load_settings
end
```
Then, you can override any particular setting inside your environments/*.rb
files.

eg: In `production.rb`
```
Figleaf::Settings.configure do |s|
  s.some_awesome_flag = false
end
```
etc...

Then, in your app, you can reference `Figleaf::Setting.some_awesome_flag?`.

Also, it provides the ability for you to define all your environment dependent
settings in just one YAML file inside `config/settings/`. The anatomy of these
files should be:

```
development:
  foo: bar
  some_bool_property: true

test:
  foo: flob
  some_bool_property: false

production:
  foo: foo
  some_bool_property: false
```

The Figleaf::Settings parser will create a namespace for your YAML file after the file
name.

Then, assuming that you named your YAML file `mysetting.yml`. you can just
access `foo` as `Figleaf::Settings.mysetting["foo"]`,
`Figleaf::Settings.mysetting[:foo]` or even `Figleaf::Settings.mysetting.foo`
(the one caveat of the method expansion is that you can't access attributes that
collide with Hash methods that way, like `key`). (Inspired by Rails'
`database.yml`, of course.) In the case of boolean values, the property is
available as a predicate (eg: `Figleaf::Settings.mysetting.some_bool_property?`)

You can also use `Figleaf::Settings.override_with_local!` to load particular
file settings in runtime.

Properties can also be lambdas.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
