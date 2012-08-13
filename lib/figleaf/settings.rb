require 'yaml'
require 'active_support/core_ext/class'
require 'pathname'

module Figleaf
  class Settings
    class_attribute :auto_define
    self.auto_define = false

    def self.configure_with_auto_define
      self.auto_define.tap do |cached_auto_define|
        self.auto_define = true
        yield self
        self.auto_define = cached_auto_define
      end
    end

    def self.configure
      self.auto_define.tap do |cached_auto_define|
        self.auto_define = false
        yield self
        self.auto_define = cached_auto_define
      end
    end

    def self.override_with_local!(local_file)
      #this file (i.e. test.local.rb) is an optional place to put settings
      local_file.tap do |local_settings_path|
        eval(IO.read(local_settings_path), binding) if File.exists?(local_settings_path)
      end
    end

    def self.method_missing(method_name, *args)
      if self.auto_define && method_name.to_s =~ /=$/ && args.length == 1
        self.define_cattr_methods(method_name)
        self.send(method_name, args.shift)
      else
        super
      end
    end

    def self.define_cattr_methods(setter_name)
      getter_name = setter_name.to_s.gsub('=','')

      cattr_writer getter_name
      define_singleton_method(getter_name) do
        result = class_variable_get "@@#{getter_name}"
        result.respond_to?(:call) ? result.call : result
      end
    end

    # Load all files in config/settings and set their contents as first level
    # citizen of Settings:
    # config/settings/some_service.yml contains
    # production:
    #   foo: bar
    # --> Settings.some_service.foo = bar
    def self.load_settings
      Dir.glob(root.join('config', 'settings', '*.yml')).each do |file|
        property_name = File.basename(file, '.yml')
        property = YAML.load_file(file)[env]
        configure_with_auto_define do |s|
          s.send("#{property_name}=", property)
        end
      end
    end

    def self.root
      return Rails.root if defined?(Rails)
      Pathname.new('.')
    end

    def self.env
      return Rails.env if defined?(Rails)
      ENV['ENVIRONMENT']
    end
  end
end
