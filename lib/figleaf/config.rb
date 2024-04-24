module Figleaf
  # Convert a ruby block to nested hash
  class Config
    def initialize = @property = LazyBlockHash.new

    def call(&block)
      instance_eval(&block)

      property
    rescue => e
      raise Settings::InvalidRb, "Configuration has invalid Ruby\n" + e.message
    end

    def method_missing(method_name, *, &) = process_method(method_name, *, &)

    def test(&) = process_method(:test, [], &)

    def process_method(method_name, *args, &block)
      @property[method_name.to_s] =
        if block_given?
          obj = self.class.new
          Proc.new { obj.call(&block) }
        else
          if args.count == 1
            args[0]
          else
            args
          end
        end
    end

    def respond_to_missing?(method_name, *args) = true

    private

      attr_reader :property
  end

  class LazyBlockHash < Hash
    def [](attr)
      val = super(attr)
      if val.is_a?(Proc)
        val.call
      else
        val
      end
    rescue => e
      raise Settings::InvalidRb, "Configuration has invalid Ruby\n" + e.message
    end
  end
end
