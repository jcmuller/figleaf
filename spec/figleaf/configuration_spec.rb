require "spec_helper"

describe Figleaf::Settings do
  describe "setters and getters" do
    context "auto define enabled" do
      before(:each) do
        described_class.auto_define = true
      end
      it "should auto define methods and set initial value when setter used" do
        described_class.fictional_feature_enabled = :on
        expect(described_class.fictional_feature_enabled).to eq(:on)
      end

      it "should return result of proc when set as a proc" do
        described_class.call_this_proc = -> { 3 }
        expect(described_class.call_this_proc).to eq(3)
      end
    end

    context "auto define disabled" do
      before(:each) do
        described_class.auto_define = true
        described_class.fictional_feature_enabled = :on
        described_class.auto_define = false
      end

      it "should not auto defined setters and getters" do
        expect { described_class.undefined_setting = :raises_error }.to raise_error(NoMethodError)
        expect { described_class.undefined_setting }.to raise_error(NoMethodError)
      end

      it "should set/get previous defined attributes" do
        expect(described_class.fictional_feature_enabled).to eq(:on)

        described_class.fictional_feature_enabled = :off
        expect(described_class.fictional_feature_enabled).to eq(:off)
      end
    end
  end

  describe "self.configure_with_auto_define" do
    it "should accept new setter values in block form" do
      described_class.configure_with_auto_define do |s|
        s.another_fictional_feature_mode = :admin
        s.enable_fictional_activity_feed = true
      end

      expect(described_class.another_fictional_feature_mode).to eq(:admin)
      expect(described_class.enable_fictional_activity_feed).to be true
    end
  end

  describe "predicate methods for boolean values" do
    it "should define predicate methods for true value" do
      described_class.configure_with_auto_define do |s|
        s.some_boolean = true
      end

      expect(described_class.some_boolean).to be true
      expect(described_class.some_boolean?).to be true
    end

    it "should define predicate methods for false value" do
      described_class.configure_with_auto_define do |s|
        s.another_boolean = false
      end

      expect(described_class.another_boolean).to be false
      expect(described_class.another_boolean?).to be false
    end

    it "should evaluate presence predicate methods for string value" do
      described_class.configure_with_auto_define do |s|
        s.not_a_boolean = "Hello, world!"
      end

      expect(described_class.not_a_boolean?).to be true
    end

    it "should return false for empty string" do
      described_class.configure_with_auto_define do |s|
        s.empty_string = ""
      end

      expect(described_class.empty_string?).to be false
    end

    it "return true for lists" do
      described_class.configure_with_auto_define do |s|
        s.not_a_boolean = %w[1 2 3]
      end

      expect(described_class.not_a_boolean?).to be true
    end
  end

  describe "self.configure" do
    before(:each) do
      described_class.auto_define = true
      described_class.fictional_feature_enabled = :on
    end

    it "should only allow setting of values for previously defined attributes" do
      described_class.configure do |s|
        s.fictional_feature_enabled = :off
      end

      expect(described_class.fictional_feature_enabled).to eq(:off)
    end

    it "should only allow setting of values for previously defined attributes" do
      expect {
        described_class.configure do |s|
          s.undefined_setting = :should_raise_error
        end
      }.to raise_error(NoMethodError)
    end
  end
end
