require "vito/utils/program_version"

describe Vito::Utils::ProgramVersion do
  let(:connection) { double(query: output) }

  subject { described_class.new("ruby -v", connection) }

  describe "#matches?" do
    context "the program exists" do
      let(:output) do
        double(success?: true,
               result: "ruby 2.0.0p195 (2013-05-14 revision 40734) [x86_64-darwin12.2.0]")
      end

      it "returns true if it matches" do
        subject.matches?("2.0.0-p195").should be_true
        subject.matches?("2.0.0p195").should be_true
        subject.matches?("2.0.0").should be_true
        subject.matches?.should be_true
      end

      it "returns false if it doesn't match" do
        subject.matches?("2.0.0p125").should be_false
        subject.matches?("1.9.3").should be_false
      end
    end

    context "the program doesn't exist" do
      let(:output) do
        double(success?: false,
               result: "ruby 2.0.0p195 fake result")
      end

      it "returns true if it matches" do
        subject.matches?("2.0.0p195").should be_false
        subject.matches?("2.0.0").should be_false
      end

      it "returns false if it doesn't match" do
        subject.matches?("2.0.0p125").should be_false
        subject.matches?("1.9.3").should be_false
        subject.matches?.should be_false
      end
    end
  end
end
