module Figleaf
  # Convert a ruby block to nested hash
  class Config
    def initialize
      @property = {}
    end

    def self.define(property_name, &block)
      property = new.define(&block)

      Settings.configure_with_auto_define do
        if Settings.respond_to?(property_name) &&
            Settings.send(property_name).respond_to?(:merge) &&
            property.respond_to?(:merge)
          property = Settings.send(property_name).merge(property)
        end

        Settings.send("#{property_name}=", property)
      end
    end

    def define(&block)
      instance_eval(&block)

      property
    end

    def method_missing(method_name, *args, &block)
      process_method(method_name, *args, &block)
    end

    def test(&block)
      process_method(:test, [], &block)
    end

    def process_method(method_name, *args, &block)
      @property[method_name.to_s] =
        if block_given?
          self.class.new.define(&block)
        else
          if args.count == 1
            args[0]
          else
            args
          end
        end
    end

    def respond_to_missing?(method_name, *args)
      true
    end

    private

      attr_reader :property
  end
end
