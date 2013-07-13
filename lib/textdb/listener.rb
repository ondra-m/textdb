require "fssm"

module Textdb
  class Listener

    def initialize
      @listener = nil
      @thread = nil
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

    # def proccess_name(b, r, t)
    #   name = r.gsub(config.data_file_extension, '')
    #   path = b.gsub(config.base_folder, '')
    #   is_directory = t == :directory ? true : false

    #   return name, path, is_directory
    # end

    def get(r)
      keys = r.split('/')
      last = keys.pop

      pointer = Textdb.root
      keys.each do |key|
        pointer = pointer[key]
      end

      return pointer, last
    end

    def create(b, r, t)
      pointer, last = get(r)

      if t == :directory
        pointer.build_key(last)
      else
        pointer.build_value(last)
      end
    end

    def update(b, r, t)
      
    end

    def delete(b, r, t)
      
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
      # Thread.kill(@thread) if @thread
    end

  end
end
