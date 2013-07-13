module Textdb
  module Data
    class Value

      attr_reader :full_path, :path, :name, :parent
      
      def initialize(path, parent)
        @full_path = File.join(Textdb.config.base_folder, path)
        @path      = path
        @name      = path.split('/')[-1].gsub(Textdb.config.data_file_extension, '')

        @parent  = parent
      end

      # [] can be only in Key
      def [](key)
        raise Textdb::ValueCannotBeKey, "#{@name} is value."
      end

      def show
        @data ||= show!
      end

      def show!
        @data = File.read(@full_path)
      end

      def update(value)
        File.open(@full_path, 'w') { |f| f.write(value) }
        show!
      end

      def destroy
        begin
          File.delete(@full_path)
          parent.delete(@name)
        rescue
          return false
        end

        return true
      end

      def inspect
        %{#<Value::0x#{object_id} @data="#{@data}">}
      end
      
    end
  end
end
