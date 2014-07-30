require 'spec_helper'

describe Figleaf::Settings do
  describe "setters and getters" do
    context "auto define enabled" do
      before(:each) do
        described_class.auto_define = true
      end
      it "should auto define methods and set initial value when setter used" do
        described_class.fictional_feature_enabled = :on
        described_class.fictional_feature_enabled.should == :on
      end

      it "should return result of proc when set as a proc" do
        described_class.call_this_proc = -> { 3 }
        described_class.call_this_proc.should == 3
      end
    end

    context "auto define disabled" do
      before(:each) do
        described_class.auto_define = true
        described_class.fictional_feature_enabled = :on
        described_class.auto_define = false
      end

      it "should not auto defined setters and getters" do
        expect { described_class.undefined_setting = :raises_error }.to raise_error
        expect { described_class.undefined_setting }.to raise_error
      end

      it "should set/get previous defined attributes" do
        described_class.fictional_feature_enabled.should eq(:on)

        described_class.fictional_feature_enabled = :off
        described_class.fictional_feature_enabled.should eq(:off)
      end
    end
  end

  describe "self.configure_with_auto_define" do
    it "should accept new setter values in block form" do
      described_class.configure_with_auto_define do |s|
        s.another_fictional_feature_mode = :admin
        s.enable_fictional_activity_feed = true
      end

      described_class.another_fictional_feature_mode.should eq(:admin)
      described_class.enable_fictional_activity_feed.should be_true
    end
  end

  describe "predicate methods for boolean values" do
    it "should define predicate methods for true value" do
      described_class.configure_with_auto_define do |s|
        s.some_boolean = true
      end

      described_class.some_boolean.should be_true
      described_class.some_boolean?.should be_true
    end

    it "should define predicate methods for false value" do
      described_class.configure_with_auto_define do |s|
        s.another_boolean = false
      end

      described_class.another_boolean.should be_false
      described_class.another_boolean?.should be_false
    end

    it "should evaluate presence predicate methods for string value" do
      described_class.configure_with_auto_define do |s|
        s.not_a_boolean = "Hello, world!"
      end

      described_class.not_a_boolean?.should be_true
    end

    it "should return false for empty string" do
      described_class.configure_with_auto_define do |s|
        s.empty_string = ""
      end

      described_class.empty_string?.should be_false
    end

    it "return true for lists" do
      described_class.configure_with_auto_define do |s|
        s.not_a_boolean = %w(1 2 3)
      end

      described_class.not_a_boolean?.should be_true
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

      described_class.fictional_feature_enabled.should == :off
    end

    it "should only allow setting of values for previously defined attributes" do
      expect {
        described_class.configure do |s|
          s.undefined_setting = :should_raise_error
        end
      }.to raise_error
    end
  end

end
