module Figleaf
  class Fighash < Hashie::Mash
    def method_missing(method_name, *args, &blk)
      return super if key?(method_name)
      case method_name
      when /.*?[?=!]$/
        super(method_name, *args, &blk)
      else
        raise NoMethodError
      end
    end

    def to_hash
      super.tap do |hash|
        keys = hash.keys
        keys.each do |key|
          hash[key.to_sym] = hash.delete(key)
        end
      end
    end
  end
end
