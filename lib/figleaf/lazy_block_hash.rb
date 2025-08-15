module Figleaf
  class LazyBlockHash < Hash
    def [](attr)
      val = super
      if val.is_a?(Proc)
        val.call
      else
        val
      end
    rescue => e
      raise Settings::InvalidRb, "Configuration has invalid Ruby\n#{e.message}"
    end
  end
end
