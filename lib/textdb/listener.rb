require "fssm"

module Textdb
  class Listener

    attr_accessor :create_skip

    def initialize
      @listener = nil
      @thread = nil

      @create_skip = []
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

    def get(r, remove_ext = false)
      keys = r.split('/')
      last = keys.pop

      if remove_ext
        last = last.gsub(config.data_file_extension, '')
      end

      pointer = Textdb.root
      keys.each do |key|
        pointer = pointer[key]
      end

      return pointer, last
    end

    def create(b, r, t)
      pointer, last = get(r)

      unless @create_skip.delete('/' + r).nil?
        return pointer[last]
      end

      if t == :directory
        pointer.build_key(last)
      else
        pointer.build_value(last)
      end
    end

    def update(b, r, t)
      pointer, last = get(r, true)

      pointer[last].show!

      puts "update (directory: #{t == :directory ? "true " : "false"}): ---#{r}---"
    end

    def delete(b, r, t)
      puts "delete (directory: #{t == :directory ? "true " : "false"}): ---#{r}---"
    end

    def start
      @thread = Thread.new {
        FSSM.monitor(config.base_folder, '**/*', directories: true) do
          create { |b, r, t| Textdb.listener.create(b, r, t) }
          update { |b, r, t| Textdb.listener.update(b, r, t) }
          delete { |b, r, t| Textdb.listener.delete(b, r, t) }
        end
      }
    end

    def stop
      Thread.kill(@thread) if @thread
    end

  end
end
