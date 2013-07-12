require "spec_helper"

describe Textdb::Configuration do
  context "in line" do
    let(:config) { Textdb.config }

    it "should be OK" do
      expect { config.base_folder = "/" }.to_not raise_error(NoMethodError)
    end

    it "should raise error" do
      expect { config.abcdefghijkl = "/" }.to raise_error(NoMethodError)
    end

    it "should be updated" do
      config.base_folder = "/abcdefghijkl"
      expect(config.base_folder).to eql("/abcdefghijkl")
    end
  end

  context "in DSL" do
    it "should be OK" do
      expect { 
        Textdb.configure do
          base_folder "/"
        end
      }.to_not raise_error(NoMethodError)
    end

    it "should raise error" do
      expect { 
        Textdb.configure do
          abcdefghijkl "/"
        end
      }.to raise_error(NoMethodError)
    end

    it "should be updated" do
      Textdb.configure do
        base_folder "/abcdefghijkl"
      end
      expect(Textdb.configure { base_folder }).to eql("/abcdefghijkl")
    end
  end
end

