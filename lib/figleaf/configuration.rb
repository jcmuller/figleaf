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
        if self.auto_define && method_name.to_s =~ /=$/ && args.length == 1
          self.define_cattr_methods(method_name)
          self.send(method_name, args.shift)
        else
          super
        end
      end

      def define_cattr_methods(setter_name)
        getter_name = setter_name.to_s.gsub('=','')

        cattr_writer getter_name
        define_singleton_method(getter_name) do
          result = class_variable_get "@@#{getter_name}"
          result.respond_to?(:call) ? result.call : result
        end
      end
    end
  end
end
