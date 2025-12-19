# frozen_string_literal: true

module Figleaf
  class Fighash < Hashie::Mash
    def method_missing(method_name, *args, &blk)
      return super if key?(method_name)
      case method_name
      when /.*?[?=!]$/
        super
      else
        raise NoMethodError
      end
    end

    def respond_to_missing?(method_name, include_all)
      return super if key?(method_name)
      case method_name
      when /.*?[?=!]$/
        super
      end

      false
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
