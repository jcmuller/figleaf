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

  end
end
