require "vito/output"

describe Vito::Output do
  describe ".write" do
    it "puts a string" do
      Vito::Output.should_receive(:puts).with("string")
      Vito::Output.write("string")
    end
  end
end
