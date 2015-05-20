module Figleaf
  class Settings
    class << self
      class_attribute :auto_define
      self.auto_define = false

      # Public - configure pre-defined attributes
      #
      def configure
        self.auto_define.tap do |cached_auto_define|
          self.auto_define = false
          yield self
          self.auto_define = cached_auto_define
        end
      end

      # Public - configure auto defined settings attributes
      # and load yaml settings from confing/settings directory
      #
      def configure!(&block)
        load_settings
        configure_with_auto_define(&block)
      end

      def configure_with_auto_define
        self.auto_define.tap do |cached_auto_define|
          self.auto_define = true
          yield self
          self.auto_define = cached_auto_define
        end
      end

      # Load all files in config/settings and set their contents as first level
      # citizen of Settings:
      # config/settings/some_service.yml contains
      # production:
      #   foo: bar
      # --> Settings.some_service.foo = bar
      def load_settings(file_pattern = default_file_pattern, env_to_load = env)
        configure_with_auto_define do
          Dir.glob(file_pattern).each do |file|
            property_name = File.basename(file, '.yml')
            property      = load_file(file)[env_to_load]

            if self.respond_to?(property_name) &&
                self.send(property_name).respond_to?(:merge) &&
                property.respond_to?(:merge)
              property = self.send(property_name).merge(property)
            end

            self.send("#{property_name}=", property)
          end
        end
      end

      def load_file(file_path, env = nil)
        property = YAML.load_file(file_path)
        property = property[env] if env
        use_hashie_if_hash(property)
      end

      def root
        return Rails.root if defined?(Rails)
        Pathname.new('.')
      end

      def default_file_pattern
        root.join('config/settings/*.yml')
      end

      def env
        return Rails.env if defined?(Rails)
        ENV['ENVIRONMENT']
      end

      def use_hashie_if_hash(property)
        return Figleaf::Fighash.new(property) if property.is_a?(Hash)
        property
      end

      def override_with_local!(local_file)
        #this file (i.e. test.local.rb) is an optional place to put settings
        local_file.tap do |local_settings_path|
          eval(IO.read(local_settings_path), binding) if File.exists?(local_settings_path)
        end
      end

      def method_missing(method_name, *args)
        getter_name, modifier = extract_getter_name_and_modifier(method_name)

        if self.auto_define && modifier == '=' && args.length == 1
          self.define_cattr_methods(getter_name)
          self.send(method_name, args.shift)
        elsif modifier == '?' && args.empty?
          self.send(getter_name).present?
        else
          super
        end
      end

      def extract_getter_name_and_modifier(method_name)
        match = method_name.to_s.match(/(?<name>.*?)(?<modifier>[?=]?)$/)
        [match[:name], match[:modifier]]
      end

      def define_cattr_methods(getter_name)
        cattr_writer getter_name
        define_singleton_method(getter_name) do
          result = class_variable_get "@@#{getter_name}"
          result.respond_to?(:call) ? result.call : result
        end
      end

    end
  end
end
