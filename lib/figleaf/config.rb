module Figleaf
  # Convert a ruby block to nested hash
  class Config
    def initialize = @property = LazyBlockHash.new

    def call(&)
      instance_eval(&)

      property
    rescue => e
      raise Settings::InvalidRb, "Configuration has invalid Ruby\n" + e.message
    end

    def method_missing(method_name, *, &) = process_method(method_name, *, &)

    def test(&) = process_method(:test, [], &)

    def process_method(method_name, *args, &block)
      @property[method_name.to_s] =
        if block
          obj = self.class.new
          proc { obj.call(&block) }
        elsif args.count == 1
          args[0]
        else
          args
        end
    end

    def respond_to_missing?(method_name, *args) = true

    private

    attr_reader :property
  end
end
