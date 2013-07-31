require "spec_helper"

describe Vito::ShellInitializer do

  describe "#run" do
    let(:recipes) { double }
    let(:dsl)     { double }
    let(:file)    { double }
    let(:another_file) { "../some_other_file" }

    context "default file" do
      before do
        File.stub(:open).with("vito.rb") { file }
        file.stub(:read) { :vitorb }
      end

      subject { described_class.new }

      it "uses ./vito.rb by default" do
        dsl.should_receive(:run).with(:vitorb)
        Vito::DslFile.stub(:new).with([]) { dsl }
        subject.run
      end
    end

    context "default file" do
      before do
        File.stub(:open).with(another_file) { file }
        file.stub(:read) { another_file }
      end

      subject { described_class.new([another_file]) }

      it "uses custom file if one is passed via args" do
        dsl.should_receive(:run).with(another_file)
        Vito::DslFile.stub(:new).with([another_file]) { dsl }
        subject.run
      end
    end
  end
end
