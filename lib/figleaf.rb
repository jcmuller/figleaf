require 'yaml'
require 'active_support/concern'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/class'
require 'pathname'

module Figleaf
  autoload :Configuration, 'figleaf/configuration'
  autoload :LoadSettings, 'figleaf/load_settings'
  autoload :Settings, 'figleaf/settings'
  autoload :VERSION, 'figleaf/version'
end
