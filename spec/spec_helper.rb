$:.unshift File.dirname(__FILE__) + '/../lib'
require "tmpdir"
require "textdb"

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  # config.filter_run :focus
  config.color_enabled = true
  config.formatter     = 'documentation'

  

  config.add_setting :dir

  config.before(:suite) {
    RSpec.configuration.dir   = Dir.mktmpdir
    Textdb.config.base_folder = RSpec.configuration.dir
    Textdb.config.listen      = true
  }
  config.after(:suite) {
    FileUtils.remove_entry_secure RSpec.configuration.dir
  }
end
