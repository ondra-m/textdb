module Textdb
  module Event
    class Processor
      
      def initialize
      end

      def config
        Textdb.config
      end

      def create(files)
        puts "create: ---#{files}---"

        files.each do |file|
          pointer, value = get(file, true)
          pointer.build_value(value)
        end
      end

      def update(files)
        puts "update: ---#{files}---"

        files.each do |file|
          pointer, value = get(file)

          value = remove_ext(value)
          
          pointer[value].nil_data
        end
      end

      def delete(files)
        puts "delete: ---#{files}---"
      end

      def get(relative, create = false)
        keys  = relative.split('/')
        value = keys.pop

        pointer = Textdb.root
        keys.each do |key|
          begin
            pointer = pointer[key]
          rescue Textdb::ExistError
            if create
              pointer = pointer.build_key(key)
            else
              pointer = pointer[key]
            end
          end
        end

        return pointer, value
      end

      def remove_ext(name)
        name.gsub(config.data_file_extension, '')
      end
      
      # def get(r, remove_ext = false)
      #   keys = r.split('/')
      #   last = keys.pop

      #   if remove_ext
      #     last = last.gsub(config.data_file_extension, '')
      #   end

      #   pointer = Textdb.root
      #   keys.each do |key|
      #     pointer = pointer[key]
      #   end

      #   return pointer, last
      # end

      # def create(b, r, t)
      #   pointer, last = get(r)

      #   unless @create_skip.delete('/' + r).nil?
      #     return pointer[last]
      #   end

      #   if t == :directory
      #     pointer.build_key(last)
      #   else
      #     pointer.build_value(last)
      #   end

      #   puts "create (directory: #{t == :directory ? "true " : "false"}): ---#{r}---"
      # end

      # def update(b, r, t)
      #   pointer, last = get(r, true)

      #   pointer[last].show!

      #   puts "update (directory: #{t == :directory ? "true " : "false"}): ---#{r}---"
      # end

      # def delete(b, r, t)
      #   puts "delete (directory: #{t == :directory ? "true " : "false"}): ---#{r}---"
      # end

    end
  end
end
