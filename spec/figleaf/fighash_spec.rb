require "spec_helper"

describe Figleaf::Fighash do
  describe "#to_hash" do
    it "should return class Hash" do
      expect(subject.to_hash.class).to eq(Hash)
    end

    context "should have symbols as keys" do
      it "for symbol keys" do
        subject = described_class.new({a: :b, c: 1, d: "foo"})
        expect(subject.to_hash).to eq({a: :b, c: 1, d: "foo"})
      end

      it "for string keys" do
        subject = described_class.new({"a" => :b, "c" => 1, "d" => "foo"})
        expect(subject.to_hash).to eq({a: :b, c: 1, d: "foo"})
      end

      it "should have symbols as keys inside two levels" do
        subject = described_class.new({a: {b: :d}})
        expect(subject.to_hash).to eq({a: {b: :d}})
      end
    end
  end
end
