# frozen_string_literal: true

require "spec_helper"

module Figleaf
  RSpec.describe Config do
    let(:code) do
      proc do
        setting_set_on_root "bar"

        default do
          foo "bar"
          bar "baz"
        end

        production do
          env "foo"
        end

        failer do
          raise "Hello"
        end

        test do
          foo "testbar"
        end
      end
    end

    subject(:config) { described_class.new }

    describe "#call" do
      subject(:called) { config.call(&code) }
      it "stores first level keywords as keys" do
        expect(called.keys).to contain_exactly(*%w[
          default
          failer
          production
          setting_set_on_root
          test
        ])
      end

      it "expands default" do
        expect(called["default"]).to eq(
          "foo" => "bar",
          "bar" => "baz"
        )
      end

      it "expands test" do
        expect(called["test"]).to eq(
          "foo" => "testbar"
        )
      end

      it "only raises when evaluating 'failer'" do
        expect { called["failer"] }.to raise_error(RuntimeError)
      end
    end
  end
end
