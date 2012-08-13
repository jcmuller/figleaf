require 'active_support/concern'
require 'active_support/core_ext/class'
require 'hashie'
require 'pathname'
require 'yaml'

module Figleaf
  autoload :Configuration, 'figleaf/configuration'
  autoload :LoadSettings, 'figleaf/load_settings'
  autoload :Settings, 'figleaf/settings'
  autoload :VERSION, 'figleaf/version'
end
