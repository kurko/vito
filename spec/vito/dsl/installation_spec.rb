require "spec_helper"

describe Vito::Dsl::Installation do
  let(:connection) { double }
  let(:ruby)       { double }
  let(:options)    { {version: "2.0.0"} }

  subject { described_class.new(:ruby, options, connection) }

  describe "#install" do
    it "installs each recipes" do
      ruby.should_receive(:install)
      Vito::Recipes::Ruby::Install.stub(:new).with(options, connection) { ruby }
      subject.install
    end
  end
end
