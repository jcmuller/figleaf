# frozen_string_literal: true

require "active_support/concern"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/hash"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/object/blank"
require "erb"
require "hashie"
require "pathname"
require "yaml"

module Figleaf
  autoload :Config, "figleaf/config"
  autoload :Fighash, "figleaf/fighash"
  autoload :LazyBlockHash, "figleaf/lazy_block_hash"
  autoload :Settings, "figleaf/settings"
  autoload :VERSION, "figleaf/version"
end
