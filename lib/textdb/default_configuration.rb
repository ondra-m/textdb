module Textdb
  
  DEFAULT_CONFIGURATION = {
    base_folder: ['/tmp/textdb', 'Textdb.rebuild'],

    data_file_extension: ['.data', 'Textdb.rebuild'],

    listen: [false, 'Textdb::Event.listener.change']
  }

end
