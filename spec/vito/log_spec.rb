require "vito/log"

describe Vito::Log do
  describe "#some_method" do
    it "returns true" do
      STDOUT.should_receive(:puts).with("messagee")
      described_class.write("messagee")
    end
  end
end
