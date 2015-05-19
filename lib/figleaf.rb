require 'active_support/concern'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/module/attribute_accessors'
require "active_support/core_ext/object/blank"
require 'hashie'
require 'pathname'
require 'yaml'

module Figleaf
  autoload :Fighash, 'figleaf/fighash'
  autoload :Configuration, 'figleaf/configuration'
  autoload :LoadSettings, 'figleaf/load_settings'
  autoload :Settings, 'figleaf/settings'
  autoload :VERSION, 'figleaf/version'
end
