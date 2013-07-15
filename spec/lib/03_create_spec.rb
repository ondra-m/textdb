require "spec_helper"

# .
# |-- key1
# |   |-- key1_1
# |   |   `-- key1_1_1
# |   |       |-- value1_1_1_1
# |   |       `-- value1_1_1_2
# |   |-- value1_1
# |   `-- value1_2
# `-- key2
#     `-- value2_1

describe "Textdb.create" do
  before(:all) do
    Textdb.config.base_folder = RSpec.configuration.dir
  end

  it "create keys" do
    expect { Textdb.create { key1.key1_1.key1_1_1.value1_1_1_1 } }.to_not raise_error
    expect { Textdb.create { key1.key1_1.key1_1_1.value1_1_1_2 } }.to_not raise_error
    expect { Textdb.create { key1.value1_1 }                     }.to_not raise_error
    expect { Textdb.create { key1.value1_2 }                     }.to_not raise_error
    expect { Textdb.create { key2.value2_1 }                     }.to_not raise_error

    list = Dir.glob(File.join(RSpec.configuration.dir, '**/*')).map { |x| x.gsub(RSpec.configuration.dir, '') }
    expect(list).to eql(["/key1", 
                         "/key1/value1_2#{Textdb.config.data_file_extension}",
                         "/key1/value1_1#{Textdb.config.data_file_extension}",
                         "/key1/key1_1",
                         "/key1/key1_1/key1_1_1",
                         "/key1/key1_1/key1_1_1/value1_1_1_1#{Textdb.config.data_file_extension}",
                         "/key1/key1_1/key1_1_1/value1_1_1_2#{Textdb.config.data_file_extension}",
                         "/key2",
                         "/key2/value2_1#{Textdb.config.data_file_extension}"])
  end

  it "require a block" do
    expect { Textdb.create }.to raise_error(Textdb::BlockRequired)
  end

  context "listen" do
    
    it "create a file" do
      expect { Textdb.read { key2.value2_2 } }.to raise_error(Textdb::ExistError)

      File.open(File.join(Textdb.config.base_folder, 'key2', 'value2_2.data'), 'w') { |f| f.write("text") }

      sleep 0.5

      expect(Textdb.read { key2.value2_2 }).to eql("text")
    end

    it ".create overrites .listen.create" do
      value_class = Textdb.create { key2.value2_3 }

      expect( Textdb.root['key2']['value2_3'] ).to eql(value_class)
    end

  end

end
