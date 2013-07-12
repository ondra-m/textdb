require "spec_helper"

describe "Textdb.update" do
  it "create with update" do
    file = File.join RSpec.configuration.dir, "key3", "value3_1#{Textdb.config.data_file_extension}"

    expect( File.exist?(file) ).to eql(false)

    expect { Textdb.create{ key3.value3_1 }.update("text") }.to_not raise_error

    expect( File.exist?(file) ).to eql(true)

    expect( File.read(file) ).to eql("text")
  end

  it "update" do
    file = File.join RSpec.configuration.dir, "key3", "value3_1#{Textdb.config.data_file_extension}"

    Textdb.update("text 2") { key3.value3_1 }

    expect( File.read(file) ).to eql("text 2")
  end

end
