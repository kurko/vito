require "vito/operating_systems/ubuntu_10"

describe Vito::OperatingSystems::Ubuntu10 do
  let(:connection) { double }

  subject { described_class.new(connection) }

  describe "is?" do
    context "correct OS" do
      it "return true if ubuntu" do
        subject.is?(:ubuntu).should be_true
      end

      it "return true if ubuntu 10" do
        subject.is?(:ubuntu, "10").should be_true
      end
    end

    context "incorrect OS" do
      it "return false if not ubuntu" do
        subject.is?(:centos).should be_false
      end

      it "return false if ubuntu 11" do
        subject.is?(:ubuntu, "11").should be_false
      end
    end
  end
end
