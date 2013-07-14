module Textdb
  module Event
    
    autoload :Processor, 'textdb/event/processor'
    autoload :Listener,  'textdb/event/listener'

    def self.listener
      @listener ||= Listener.new
    end

    def self.processor
      @processor ||= Processor.new
    end

  end
end
