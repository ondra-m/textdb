module Textdb
  module Event
    class Processor
      
      def initialize
      end

      def config
        Textdb.config
      end

      def create(files)
        files.each do |file|
          pointer, value = get(file, true)
          pointer.build_value(value)
        end
      end

      def update(files)
        files.each do |file|
          pointer, value = get(file)

          value = remove_ext(value)
          
          pointer[value].nil_data
        end
      end

      def delete(files)
        files.each do |file|
          pointer, value = get(file)

          value = remove_ext(value)

          begin
            value_class = pointer[value]
            value_class.destroy_value
          rescue Textdb::ExistError
          end
        end
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

    end
  end
end
