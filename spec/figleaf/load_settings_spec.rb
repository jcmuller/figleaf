require 'spec_helper'

class FigleafLoadSettingsImplementer
  include Figleaf::Configuration
  include Figleaf::LoadSettings
end

describe Figleaf::LoadSettings do
  let(:described_class) { FigleafLoadSettingsImplementer }

  describe "self.load_settings" do
    let(:configuration) {
      {
        "test" => {
          "foo" => "bar",
          "bool_true" => true,
          "bool_false" => false
        }
      }
    }

    before do
      Dir.stub(:glob).and_return(["config/described_class/some_service.yml"])
      described_class.stub(:env).and_return("test")
      YAML.stub(:load_file).and_return(configuration)

      described_class.load_settings
    end

    it "should load some service" do
      described_class.some_service["foo"].should == "bar"
    end

    it "should load indifferently the key names" do
      described_class.some_service["foo"].should == "bar"
      described_class.some_service[:foo].should == "bar"
    end

    it "should create foo as a method" do
      described_class.some_service.foo.should == "bar"
    end

    it "should create bool_true? and return true" do
      described_class.some_service.bool_true?.should be_true
    end

    it "should create bool_false? and return false" do
      described_class.some_service.bool_false?.should be_false
    end

    it "should work for arrays as well" do
      YAML.stub(:load_file).and_return({ "test" => [1, 2] })
      described_class.load_settings
      described_class.some_service.should == [1, 2]
    end

    it "and for plain strings" do
      YAML.stub(:load_file).and_return({ "test" => "Hello, World!" })
      described_class.load_settings
      described_class.some_service.should == "Hello, World!"
    end

    it "and for booleans (true)" do
      YAML.stub(:load_file).and_return({ "test" => true })
      described_class.load_settings
      described_class.some_service.should be_true
    end

    it "and for booleans (false)" do
      YAML.stub(:load_file).and_return({ "test" => false })
      described_class.load_settings
      described_class.some_service.should be_false
    end

    it "should raise exception when loading an undefined value" do
      YAML.stub(:load_file).and_return({ "test" => {} })
      described_class.load_settings
      expect { described_class.some_service.blah }.to raise_error NoMethodError
    end

  end
end
