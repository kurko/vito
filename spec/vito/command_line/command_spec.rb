require "spec_helper"

describe Vito::CommandLine::Command do
  let(:options)      { double }
  let(:command_line) { double(options: options) }

  subject { described_class.new(command_line) }

  describe "#command" do
    it "returns help if --help is passed" do
      options.stub(help: true)
      subject.command.should == "help"
    end

    it "returns run by default" do
      options.stub(help: false)
      subject.command.should == "run"
    end
  end
end
