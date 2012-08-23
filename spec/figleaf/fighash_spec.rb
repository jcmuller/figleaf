require 'spec_helper'

describe Figleaf::Fighash do
  describe "#to_hash" do
    it "should return class Hash" do
      subject.to_hash.class.should == Hash
    end

    context "should have symbols as keys" do
      it "for symbol keys" do
        subject = described_class.new({ a: :b, c: 1, d: "foo" })
        subject.to_hash.should == { a: :b, c: 1, d: "foo" }
      end

      it "for string keys" do
        subject = described_class.new({ "a" => :b, "c" => 1, "d" => "foo" })
        subject.to_hash.should == { a: :b, c: 1, d: "foo" }
      end

      it "should have symbols as keys inside two levels" do
        subject = described_class.new({ a: { b: :d } })
        subject.to_hash.should == { a: { b: :d } }
      end
    end
  end
end
