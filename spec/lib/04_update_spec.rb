require "spec_helper"

describe "Textdb.update" do
  let(:base_folder)   { Textdb.config.base_folder }
  let(:data_file_ext) { Textdb.config.data_file_extension }

  it "create with update" do
    file = File.join base_folder, "key3", "value3_1#{data_file_ext}"

    expect( File.exist?(file) ).to eql(false)

    expect { Textdb.create{ key3.value3_1 }.update("text") }.to_not raise_error

    expect( File.exist?(file) ).to eql(true)

    expect( File.read(file) ).to eql("text")
  end

  it "update" do
    file = File.join base_folder, "key3", "value3_1#{data_file_ext}"

    Textdb.update("text 2") { key3.value3_1 }

    expect( File.read(file) ).to eql("text 2")
  end

  context "listen" do
    it "update a file" do
      Textdb.create { key3.value3_2 }.update("text")

      sleep 0.5

      expect( Textdb.read { key3.value3_2 } ).to eql("text")

      file = File.join Textdb.config.base_folder, "key3", "value3_2#{data_file_ext}"

      File.open(file, 'w') { |f| f.write("text 2") }

      sleep 0.5

      expect( Textdb.read { key3.value3_2 } ).to eql("text 2")
    end
  end
end
