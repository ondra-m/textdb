require "textdb/configuration"
require "textdb/default_configuration"
require "textdb/error"
require "textdb/version"

module Textdb

  autoload :Data,        'textdb/data'
  autoload :BlockMethod, 'textdb/block_method'

  # Global
  # -----------------------------------------------------------------
  def self.config
    @config ||= Textdb::Configuration.new(DEFAULT_CONFIGURATION)
  end

  def self.configure(&block)
    config.instance_eval(&block)
  end

end
