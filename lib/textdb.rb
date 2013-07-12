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
  def self.get(&block)
    keys    = Textdb::BlockMethod.get(&block)
    pointer = root

    keys.each do |key|
      pointer = pointer[key.to_s]
    end

    pointer
  end

  def self.read(&block)
    unless block_given?
      raise Textdb::BlockRequired, "Read action require a block."
    end

    get(&block).show
  end

  def self.update(value, &block)
    unless block_given?
      raise Textdb::BlockRequired, "Update action require a block."
    end

    get(&block).update(value)
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
        if pointer.class.name == 'Textdb::Data::Value'
          raise Textdb::ValueCannotBeKey, "'#{key}' is already Value, cannot be Key."
        else
          pointer = pointer.create_key(key)
        end
      end
    end

    begin
      pointer = pointer[value]
      case pointer.class.name
      when 'Textdb::Data::Key';   raise(Textdb::AlreadyExist, "#{value} already exist as key.")
      when 'Textdb::Data::Value'; raise(Textdb::AlreadyExist, "#{value} already exist.")
      end
    rescue Textdb::ExistError
      pointer.create_value(value)
    end
  end

end
