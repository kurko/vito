require "vito/operating_system"

describe Vito::OperatingSystem do
  subject { described_class.new(:connection) }

  before do
    stub_const("Vito::OperatingSystems::Ubuntu10", Class.new)
  end

  describe "#os" do
    it "instantiates Ubuntu 10" do
      Vito::OperatingSystems::Ubuntu10.stub(:new).with(:connection) { :os }
      subject.os.should == :os
    end
  end
end
