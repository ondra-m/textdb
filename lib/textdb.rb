require "textdb/configuration"
require "textdb/default_configuration"
require "textdb/error"
require "textdb/version"

module Textdb
  
  # Global
  # -----------------------------------------------------------------
  def self.config
    @config ||= Textdb::Configuration.new(DEFAULT_CONFIGURATION)
  end

  def self.configure(&block)
    config.instance_eval(&block)
  end

end
