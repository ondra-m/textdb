require "spec_helper"

describe Textdb::BlockMethod do

  let(:block) { Textdb::BlockMethod }

  it "sequence of calling" do
    expect( block.get { a.b.c } ).to eql(['a', 'b', 'c'])
  end

  it "empty block" do
    expect( block.get { } ).to eql([])
  end
end
