require "spec_helper"
require "vito/connection"
require "vito/log"

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

      its(:success?) { should be_false }
      its(:result)   { should == "sh: harrr: command not found\n" }
    end
  end
end
