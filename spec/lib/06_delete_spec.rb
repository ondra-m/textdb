require "spec_helper"

describe "Textdb.delete" do
  let(:base_folder)   { Textdb.config.base_folder }
  let(:data_file_ext) { Textdb.config.data_file_extension }

  before(:all) do
    Textdb.create { key5.key5_1.value5_1_1 }
    Textdb.create { key5.key5_1.value5_1_2 }
    Textdb.create { key5.key5_1.value5_1_3 }
    Textdb.create { key5.value5_1          }
    Textdb.create { value6                 }
    Textdb.create { key6.value6_1          }
  end

  it "value" do
    file = File.join base_folder, "key5", "key5_1", "value5_1_1#{data_file_ext}"

    expect( File.exist?(file) ).to eql(true)

    Textdb.delete { key5.key5_1.value5_1_1 }

    expect( File.exist?(file) ).to eql(false)

    expect { Textdb.read { key5.key5_1.value5_1_1 } }.to raise_error(Textdb::ExistError)
  end

  it "key" do
    dir = File.join base_folder, "key6"

    expect( Dir.exist?(dir) ).to eql(true)

    Textdb.delete { key6 }

    expect( Dir.exist?(dir) ).to eql(false)

    expect { Textdb.read { key6 } }.to raise_error(Textdb::ExistError)
  end

  it "recursive" do
    dir = File.join base_folder, "key5"

    Textdb.delete { key5 }

    expect( Dir.exist?(dir) ).to eql(false)

    expect { Textdb.read { key5.key5_1.value5_1_2 } }.to raise_error(Textdb::ExistError)
    expect { Textdb.read { key5.key5_1.value5_1_3 } }.to raise_error(Textdb::ExistError)
    expect { Textdb.read { key5.value5_1          } }.to raise_error(Textdb::ExistError)
  end

  context "listen" do
    it "delete a file" do
      Textdb.create { key5.key5_2.value5_2_1 }

      sleep 0.5
      
      file = File.join base_folder, "key5", "key5_2", "value5_2_1#{data_file_ext}"

      File.delete(file)

      sleep 0.5

      expect { Textdb.read { key5.key5_2.value5_2_1 } }.to raise_error(Textdb::ExistError)
    end
  end
end
