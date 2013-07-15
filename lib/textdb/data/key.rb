module Textdb
  module Data
    class Key < Hash

      attr_reader :full_path, :path, :name, :parent

      def initialize(path, parent)
        @full_path = File.join(Textdb.config.base_folder, path)
        @path      = path
        @name      = path.split('/')[-1]

        @parent = parent

        load_keys
        load_values
      end

      def default(key)
        raise Textdb::ExistError, "#{key} does not exist."
      end



      # Auto load
      # -----------------------------------------------------------------
      def keys_glob
        File.join(@full_path, "*/")
      end

      def values_glob
        File.join(@full_path, "*#{Textdb.config.data_file_extension}")
      end

      def load_keys
        Dir.glob(keys_glob) do |f|
          build_key(File.basename(f))
        end
      end

      def load_values
        Dir.glob(values_glob) do |f|
          build_value(File.basename(f))
        end
      end



      # Build and create
      # -----------------------------------------------------------------
      def build_key(name)
        self[name] = Textdb::Data::Key.new(File.join(@path, name), self)
        self[name]
      end

      # Listener listen only for file
      def build_value(name)
        name_without_ext = name.gsub(Textdb.config.data_file_extension, "")

        begin
          self[name_without_ext]
        rescue Textdb::ExistError
          self[name_without_ext] = Textdb::Data::Value.new(File.join(@path, name), self)
          self[name_without_ext]
        end
      end

      def create_key(name)
        Dir.mkdir(File.join(@full_path, name))

        build_key(name)
      end

      def create_value(name)
        name = "#{name}#{Textdb.config.data_file_extension}"

        File.open(File.join(@full_path, name), 'w') { |f| f.write('') }
        build_value(name)
      end

      def show
        self
      end

      # This method is available only in the Value class.
      def update
        raise Textdb::UpdateOnKey, "Key cannot be updated."
      end

      def destroy
        self.each do |key, value|
          # Value -> key representing name of the value
          if key.is_a?(String)
            value.destroy
          else
            key.destroy
          end
        end

        begin
          FileUtils.remove_entry_secure(@full_path)
          parent.delete(@name)
        rescue
          return false
        end
        
        return true
      end
        
    end
  end
end
