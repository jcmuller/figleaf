require 'spec_helper'
require 'settings'

describe Settings do

  describe "setters and getters" do
    context "auto define enabled" do
      before(:each) do
        Settings.auto_define = true
      end
      it "should auto define methods and set initial value when setter used" do
        Settings.fictional_feature_enabled = :on
        Settings.fictional_feature_enabled.should == :on
      end

      it "should return result of proc when set as a proc" do
        Settings.call_this_proc = -> { 3 }
        Settings.call_this_proc.should == 3
      end
    end

    context "auto define disabled" do
      before(:each) do
        Settings.auto_define = true
        Settings.fictional_feature_enabled = :on
        Settings.auto_define = false
      end
      it "should not auto defined setters and getters" do
        lambda {
          Settings.undefined_setting = :raises_error
        }.should raise_error

        lambda {
          Settings.undefined_setting
        }.should raise_error
      end

      it "should set/get previous defined attributes" do
        Settings.fictional_feature_enabled.should eq(:on)

        Settings.fictional_feature_enabled = :off
        Settings.fictional_feature_enabled.should eq(:off)
      end
    end
  end

  describe "self.configure_with_auto_define" do
    it "should accept new setter values in block form" do
      Settings.configure_with_auto_define do |s|
        s.another_fictional_feature_mode = :admin
        s.enable_fictional_activity_feed = true
      end

      Settings.another_fictional_feature_mode.should eq(:admin)
      Settings.enable_fictional_activity_feed.should be_true
    end
  end

  describe "self.configure" do
    before(:each) do
      Settings.auto_define = true
      Settings.fictional_feature_enabled = :on
    end

    it "should only allow setting of values for previously defined attributes" do
      Settings.configure do |s|
        s.fictional_feature_enabled = :off
      end

      Settings.fictional_feature_enabled.should == :off
    end

    it "should only allow setting of values for previously defined attributes" do
      lambda {
        Settings.configure do |s|
          s.undefined_setting = :should_raise_error
        end
      }.should raise_error
    end
  end

  describe "self.load_settings" do
    it "should load google analytics" do
      Dir.should_receive(:glob).and_return(["config/settings/some_service.yml"])
      Settings.should_receive(:env).and_return("test")
      YAML.should_receive(:load_file).and_return({"test" => "foo"})
      Settings.load_settings
      Settings.some_service.should == "foo"
    end
  end

end
