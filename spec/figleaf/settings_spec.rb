require 'spec_helper'

describe Figleaf::Settings do

  describe "self.load_file" do
    before do
      @fixture_path = File.expand_path("../../fixtures/service.yml", __FILE__)
    end

    it "converts file settings from given env" do
      settings = described_class.load_file(@fixture_path, "test")
      expect(settings.foo).to eq("bar")
    end

    it "allows env to be optional" do
      settings = described_class.load_file(@fixture_path)
      expect(settings.test.foo).to eq("bar")
    end

    it "returns nil for missing env" do
      settings = described_class.load_file(@fixture_path, "foo")
      expect(settings).to eq(nil)
    end
  end

  describe "self.load_settings" do
    before do
      @fixtures_path = File.expand_path("../../fixtures/*.yml", __FILE__)

      described_class.load_settings(@fixtures_path, "test")
    end

    it "load some service" do
      expect(described_class.service["foo"]).to eq("bar")
    end

    it "load indifferently the key names" do
      expect(described_class.service["foo"]).to eq("bar")
      expect(described_class.service[:foo]).to eq("bar")
    end

    it "create foo as a method" do
      expect(described_class.service.foo).to eq("bar")
    end

    it "create bool_true? and return true" do
      expect(described_class.service.bool_true?).to eq(true)
    end

    it "create bool_false? and return false" do
      expect(described_class.service.bool_false?).to eq(false)
    end

    it "work for array as well" do
      expect(described_class.array).to eq([1, 2])
    end

    it "and for plain string" do
      expect(described_class.string).to eq("Hello, World!")
    end

    it "and for boolean (true)" do
      expect(described_class.boolean).to eq(true)
    end

    it "and for boolean (false)" do
      described_class.load_settings(@fixtures_path, "alt")
      expect(described_class.boolean).to eq(false)
    end

    it "raise exception when loading an undefined value" do
      YAML.stub(:load_file).and_return({ "test" => {} })
      described_class.load_settings
      expect { described_class.service.blah }.to raise_error NoMethodError
    end

    context "overloading settings" do
      before do
        overload = File.expand_path("../../fixtures/extra/*.yml", __FILE__)
        described_class.load_settings(overload, "test")
      end

      it "merge values for matching env" do
        expect(described_class.service.foo).to eq 'overridden'
        expect(described_class.service.extra).to eq 'extra'
        expect(described_class.service.bool_false).to eq(false)
        expect(described_class.service.bool_true).to eq(true)
      end

      it "not change existing settings for missing env" do
        expect(described_class.array).to eq([1, 2]) # remains unchanged
      end

      it "not change settings when overloaded file blank" do
        expect(described_class.boolean).to eq(true) # remains unchanged
      end
    end
  end
end
