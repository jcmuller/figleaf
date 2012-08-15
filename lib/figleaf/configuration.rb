module Figleaf
  module Configuration
    extend ActiveSupport::Concern

    included do
      class_attribute :auto_define
      self.auto_define = false
    end

    module ClassMethods
      def configure_with_auto_define
        self.auto_define.tap do |cached_auto_define|
          self.auto_define = true
          yield self
          self.auto_define = cached_auto_define
        end
      end

      def configure
        self.auto_define.tap do |cached_auto_define|
          self.auto_define = false
          yield self
          self.auto_define = cached_auto_define
        end
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
