# frozen_string_literal: true

require "spec_helper"

describe Figleaf::Settings do
  # Force a freshly loaded Figleaf::Settings class on every test run
  before do
    Figleaf.send(:remove_const, :Settings) if Figleaf.const_defined?(:Settings)
    load "lib/figleaf/settings.rb"
  end

  # Force a new reference to the class
  subject(:described_class) { Figleaf::Settings }

  describe "self.load_settings" do
    let(:fixtures_path) { File.expand_path("../../fixtures/*.yml", __FILE__) }

    before { described_class.load_settings(fixtures_path, "test") }

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
      described_class.load_settings(fixtures_path, "alt")
      expect(described_class.boolean).to eq(false)
    end

    it "and for erb values" do
      expect(described_class.erb.foo).to eq("foo")
      expect(described_class.erb.bar).to be_nil
    end

    it "and for regexp values" do
      expect(described_class.regexp.some_matcher).to eq(/\Amatcher\z/)
    end

    it "raise exception when loading an undefined value" do
      allow(YAML).to receive(:load_yaml_file).and_return({"test" => {}})
      described_class.load_settings
      expect { described_class.service.blah }.to raise_error NoMethodError
    end

    context "with bad files" do
      context "yaml" do
        let(:overload) { File.expand_path("../../fixtures/errors/*.yml", __FILE__) }

        it "reports the file that has errors" do
          expect { described_class.load_settings(overload, "test") }
            .to raise_error(described_class::InvalidYAML)
        end
      end

      context "rb" do
        let(:overload) { File.expand_path("../../fixtures/errors/*.rb", __FILE__) }

        it "reports the file that has errors" do
          expect { described_class.load_settings(overload, "test") }
            .to raise_error(described_class::InvalidRb)
        end
      end
    end

    context "incompatible types" do
      context "bad overrides" do
        subject(:settings) { described_class.bad_overrides }

        let(:fixtures_path) { File.expand_path("../../fixtures/type_errors/bad_overrides.yml", __FILE__) }

        it "raises an error when overloading a hash with an array" do
          expect { described_class.load_settings(fixtures_path, "array") }
            .to raise_error(described_class::MismatchedTypes)
        end

        it "raises an error when overloading a hash with a string" do
          expect { described_class.load_settings(fixtures_path, "string") }
            .to raise_error(described_class::MismatchedTypes)
        end

        it "raises an error when overloading a hash with a bool" do
          expect { described_class.load_settings(fixtures_path, "bool") }
            .to raise_error(described_class::MismatchedTypes)
        end
      end
    end

    context "overloading settings" do
      before do
        overload = File.expand_path("../../fixtures/extra/*.yml", __FILE__)
        described_class.load_settings(overload, "test")
      end

      it "merge values for matching env" do
        expect(described_class.service.foo).to eq "overridden"
        expect(described_class.service.extra).to eq "extra"
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

    context "default is applied" do
      before do
        default = File.expand_path("../../fixtures/extra/default.yml", __FILE__)
        described_class.load_settings(default, "test")
      end

      it "overrides values" do
        expect(described_class.default.foo).to eq("overridden")
      end

      it "respects values set in default" do
        expect(described_class.default.bar).to eq("baz")
      end
    end

    context "using default as a YAML anchor is OK" do
      before do
        default_anchor = File.expand_path("../../fixtures/extra/default_anchor.yml", __FILE__)
        described_class.load_settings(default_anchor, "test")
      end

      it "overrides values" do
        expect(described_class.default_anchor.foo).to eq("overridden")
      end

      it "respects values set in default_anchor" do
        expect(described_class.default_anchor.bar).to eq("baz")
      end
    end
  end

  shared_examples_for "merged hashes" do
    context "when using the default" do
      before { described_class.load_settings(fixtures_path, "some_env") }

      it "test a non overridden environment" do
        expect(merged).to match(
          "leaf1" => "default1",
          "root1" => {"leaf11" => "default2"},
          "root2" => {
            "leaf21" => "default3",
            "root21" => {
              "leaf211" => "default4",
              "root211" => {"leaf2111" => "default5"}
            }
          }
        )
      end
    end

    context "with an overridden environment" do
      before { described_class.load_settings(fixtures_path, "overridden") }

      it "merges the values" do
        expect(merged).to match(
          "leaf1" => "default1",
          "leaf2" => "overridden1",
          "root1" => {"leaf11" => "overridden2"},
          "root2" => {
            "leaf21" => "default3",
            "leaf22" => "overridden3",
            "root21" => {
              "leaf211" => "overridden4",
              "root211" => {
                "leaf2111" => "default5",
                "leaf2112" => "overridden5"
              }
            }
          }
        )
      end
    end
  end

  context "load yaml files" do
    let(:fixtures_path) { File.expand_path("../../fixtures/**/*.yaml", __FILE__) }

    before { described_class.load_settings(fixtures_path, "test") }

    it "reads them just fine" do
      expect(described_class.yaml.works).to eq("here")
    end

    context "hashes are merged" do
      subject(:merged) { described_class.merged_yaml }
      it_behaves_like "merged hashes"
    end
  end

  context "load ruby files" do
    let(:fixtures_path) { File.expand_path("../../fixtures/extra/*.rb", __FILE__) }

    before { described_class.load_settings(fixtures_path, "test") }

    it "load indifferently the key names" do
      expect(described_class.code["foo"]).to eq("bar")
      expect(described_class.code[:foo]).to eq("bar")
    end

    it "create foo as a method" do
      expect(described_class.code.foo).to eq("bar")
    end

    it "create bool_true? and return true" do
      expect(described_class.code.bool_true?).to eq(true)
    end

    it "create bool_false? and return false" do
      expect(described_class.code.bool_false?).to eq(false)
    end

    it "work for array as well", :aggregate_failures do
      expect(described_class.code.array).to eq([1, 2, 3, 4])
      expect(described_class.code.array_alt).to eq([1, 2, 3, 4])
    end

    it "and for boolean (true)" do
      expect(described_class.code.bool_true).to eq(true)
    end

    it "and for boolean (false)" do
      expect(described_class.code.bool_false).to eq(false)
    end

    it "and for ENV values" do
      expect(described_class.code.from_env).to eq("foo")
    end

    it "and for regexp values" do
      expect(described_class.regexp.value).to eq(/\Amatcher\z/)
    end

    context "hashes are merged" do
      subject(:merged) { described_class.merged_rb }
      it_behaves_like "merged hashes"
    end
  end
end
