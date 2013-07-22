require "spec_helper"

describe Vito::ShellInitializer do
  subject { described_class.new(:argv) }

  describe "#run" do
    let(:recipes) { double }
    let(:dsl)     { double }
    let(:file)    { double }

    before do
      File.stub(:open).with("vito.rb") { file }
      file.stub(:read) { :vitorb }
    end

    it "uses ./vito.rb by default" do
      dsl.should_receive(:run).with(:vitorb)
      Vito::DslFile.stub(:new).with(:argv) { dsl }
      subject.run
    end
  end
end
