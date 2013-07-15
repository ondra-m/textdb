require "listen"

module Textdb
  module Event
    class Listener

      def initialize
      end

      def config
        Textdb.config
      end

      def change
        if config.listen
          start
        else
          stop
        end
      end

      def start
        @listener = Listen.to(config.base_folder)
                          .filter(filter)
                          .change(&callback)

        @listener.start
      end

      def stop
        @listener.stop
      end



      # Options for listen gem
      # -----------------------------------------------------------------
      def filter
        /#{config.data_file_extension.gsub('.', '\.')}$/
      end

      def processor
        Textdb::Event.processor
      end

      def callback
        Proc.new do |modified, added, removed|
          processor.create(added)    unless added.empty?
          processor.update(modified) unless modified.empty?
          processor.delete(removed)  unless removed.empty?
        end
      end

    end
  end
end
