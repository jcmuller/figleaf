Settings
========

YAML based DRY settings manager.


Synopsis
========
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
