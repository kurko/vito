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
      its(:result)   { should == "Alex" }
    end

    context "invalid command" do
      let(:command) { "harrr" }

      it "raises error and logs its messages" do
        Vito::Log.should_receive(:raise).with("An error occurred. Here's the stacktrace:")
        Vito::Log.should_receive(:raise).with(/sh.*harrr.*not found\n/)
        Vito::Log.stub(:raise)

        expect{ subject }.to raise_error "Error."
      end
    end
  end
end
