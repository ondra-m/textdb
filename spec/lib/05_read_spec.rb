require "spec_helper"

describe "Textdb.read" do
  before(:all) do
    Textdb.create{ key4.key4_1.value4_1_1 }.update("text 1")
    Textdb.create{ key4.key4_1.value4_1_2 }.update("text 2")
    Textdb.create{ key4.key4_1.value4_1_3 }.update("text 3")
    Textdb.create{ key4.value4_1          }.update("text 4")
    Textdb.create{ value1                 }.update("text 5")
  end

  it "read before create" do
    expect { Textdb.read { key4.key4_2.value4_2_1 } }.to raise_error(Textdb::ExistError)
  end

  it "read" do
    expect( Textdb.read { key4.key4_1.value4_1_1 } ).to eql("text 1")
    expect( Textdb.read { key4.key4_1.value4_1_2 } ).to eql("text 2")
    expect( Textdb.read { key4.key4_1.value4_1_3 } ).to eql("text 3")
    expect( Textdb.read { key4.value4_1          } ).to eql("text 4")
    expect( Textdb.read { value1                 } ).to eql("text 5")
  end

  it "file read" do
    dir = Textdb.config.base_folder
    ext = Textdb.config.data_file_extension

    expect( File.read File.join(dir, "key4", "key4_1", "value4_1_1#{ext}") ).to eql("text 1")
    expect( File.read File.join(dir, "key4", "key4_1", "value4_1_2#{ext}") ).to eql("text 2")
    expect( File.read File.join(dir, "key4", "key4_1", "value4_1_3#{ext}") ).to eql("text 3")
    expect( File.read File.join(dir, "key4", "value4_1#{ext}"            ) ).to eql("text 4")
    expect( File.read File.join(dir, "value1#{ext}"                      ) ).to eql("text 5")
  end

  it "without block" do
    expect { Textdb.read }.to raise_error(Textdb::BlockRequired)
  end
end
