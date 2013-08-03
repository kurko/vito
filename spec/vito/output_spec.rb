require "vito/output"

describe Vito::ConnectionOutput do
  let(:stdout) { double(read: "stdout_string\n\n\s") }
  let(:stderr) { double(read: :stderr_string) }
  let(:thread) { double(value: double(exitstatus: 0)) }

  subject { described_class.new(nil, stdout, stderr, thread) }

  describe "success?" do
    it "returns true if exit status is successful" do
      subject.success?.should be_true
    end

    it "returns false if exit status isn't successful" do
      thread.stub_chain(:value, :exitstatus) { 128 }
      subject.success?.should be_false
    end
  end

  describe "result" do
    it "returns stdout string in case of a successful command" do
      subject.stub(:success?) { true }
      subject.result.should == "stdout_string"
    end

    it "returns stdout string in case of a successful command" do
      subject.stub(:success?) { false }
      subject.result.should == :stderr_string
    end
  end
end
