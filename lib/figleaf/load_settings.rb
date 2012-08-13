require 'pry'
module Figleaf
  module LoadSettings
    extend ActiveSupport::Concern

    module ClassMethods
      # Load all files in config/settings and set their contents as first level
      # citizen of Settings:
      # config/settings/some_service.yml contains
      # production:
      #   foo: bar
      # --> Settings.some_service.foo = bar
      def load_settings
        Dir.glob(root.join('config', 'settings', '*.yml')).each do |file|
          property_name = File.basename(file, '.yml')
          property = YAML.load_file(file)[env]
          self.configure_with_auto_define do |s|
            s.send("#{property_name}=", property)
          end
        end
      end

      def root
        return Rails.root if defined?(Rails)
        Pathname.new('.')
      end

      def env
        return Rails.env if defined?(Rails)
        ENV['ENVIRONMENT']
      end

    end
  end
end
