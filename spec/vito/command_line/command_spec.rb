require "spec_helper"

describe Vito::CommandLine::Command do
  let(:argv) { double }
  let(:dsl_file) { double }
  subject { described_class.new(argv) }

  describe "#run" do
    describe "no command given" do
      it "runs the default operation" do
        Vito::DslFile.should_receive(:new).with(subject) { dsl_file }
        dsl_file.should_receive(:run)
        subject.run
      end
    end
  end

  describe "#options" do
    it "returns an options object" do
      Vito::CommandLine::Options.stub(:new).with(argv) { :options }
      subject.options.should == :options
    end
  end
end
