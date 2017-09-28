require 'spec_helper'

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

        dev_int do
          bar "baz"
        end

        test do
          foo "overridden"
        end
      end
    end

    subject(:config) { described_class.new }

    describe "#call" do
      it "lets you configure stuff using code" do
        expect(Settings.some_thing).to eq(
          "setting_set_on_root" => "bar",
          "default" => {
            "foo" => "bar",
            "bar" => "baz",
          },
          "test" => {
            "foo" => "overridden"
          },
          "dev_int" => {
            "bar" => "baz"
          },
          "production" => {
            "env" => "foo"
          }
        )
      end
    end
  end
end