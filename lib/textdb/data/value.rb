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
      
    end
  end
end
