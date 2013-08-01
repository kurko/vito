require "spec_helper"

describe Vito::CommandLine::Options do
  let(:argv) { [] }

  subject { described_class.new(argv) }

  describe "#file" do
    context "file is passed in" do
      let(:argv) { ["-f", "some_path"] }
      its(:file) { should == "some_path" }
    end

    context "command and file are passed in" do
      let(:argv) { ["install", "-f", "some_path"] }
      its(:file) { should == "some_path" }
    end

    context "no file is passed in" do
      let(:argv) { ["-x", "no_file"] }
      its(:file) { should be_nil }
    end
  end

  describe "#help" do
    context "-h is passed in" do
      let(:argv) { ["-f", "some_path", "-h"] }
      its(:help) { should be_true }
    end

    context "--help is passed in" do
      let(:argv) { ["-f", "some_path", "--help"] }
      its(:help) { should be_true }
    end

    context "neither -h nor --help is passed in" do
      let(:argv) { ["-f", "some_path"] }
      its(:help) { should be_false }
    end
  end

  describe "#available_options" do
    it "returns all available options" do
      subject.available_options.should == [
        [["-f", "--file filename"], "Defines a file"],
        [["-h", "--help"], "Shows this documentation"]
      ]
    end
  end
end
