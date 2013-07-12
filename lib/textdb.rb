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

  def self.root
    @root ||= Textdb::Data::Key.new('/', nil)
  end

  def self.rebuild
    @root = nil
  end


  # Data
  # -----------------------------------------------------------------
  def self.read(&block)
    unless block_given?
      raise Textdb::BlockRequired, "Read action require a block."
    end

    keys    = Textdb::BlockMethod.get(&block)
    pointer = root

    keys.each do |key|
      pointer = pointer[key.to_s]
    end

    pointer.show
  end

end
