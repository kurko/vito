require "spec_helper"

describe Vito::Connection do
  before do
    STDOUT.stub(:puts)
  end

  subject { described_class.new(:ssh, {command: command}).run("Alex") }

  describe "#run" do
    context "valid command" do
      let(:command) { "echo" }

      its(:success?) { should == true }
      its(:result)   { should == "Alex\n" }
    end

    context "invalid command" do
      let(:command) { "harrr" }

      it "raises error and logs its messages" do
        Vito::Log.should_receive(:write).exactly(2).times
        Vito::Log.should_receive(:write).with("An error occurred. Here's the stacktrace:")
        Vito::Log.should_receive(:write).with("sh: harrr: command not found\n")
        Vito::Log.should_receive(:write).exactly(1).times

        expect{ subject }.to raise_error 
      end
    end
  end
end
