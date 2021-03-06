require "textdb/configuration"
require "textdb/default_configuration"
require "textdb/error"
require "textdb/version"

# TODO:
#   - nicer method
#   - check data file extension only at the end of name
#   - documentation
#   - unite textdb.* and event.processor.* methods
#   - Event.processor - delete also the key

module Textdb

  autoload :Data,        'textdb/data'
  autoload :BlockMethod, 'textdb/block_method'
  autoload :Event,       'textdb/event'



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
  def self.get(&block)
    unless block_given?
      raise Textdb::BlockRequired, "This action require a block."
    end

    keys    = Textdb::BlockMethod.get(&block)
    pointer = root

    keys.each do |key|
      pointer = pointer[key.to_s]
    end

    pointer
  end

  def self.read(&block)
    get(&block).show
  end

  def self.update(value, &block)
    get(&block).update(value)
  end

  def self.destroy(&block)
    get(&block).destroy
  end

  def self.delete(&block)
    destroy(&block)
  end

  # TODO: Make the method nicer
  def self.create(&block)
    unless block_given?
      raise Textdb::BlockRequired, "Creates action require a block."
    end

    keys    = Textdb::BlockMethod.get(&block)
    value   = keys.pop
    pointer = root

    keys.each do |key|
      begin
        pointer = pointer[key]
      rescue Textdb::ExistError
        pointer = pointer.create_key(key)
      end
    end

    begin
      pointer = pointer[value]
      raise Textdb::AlreadyExist, "#{value} already exist."
    rescue Textdb::ExistError
      pointer.create_value(value)
    end
  end

end
