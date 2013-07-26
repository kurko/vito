require "spec_helper"

describe Vito::Log do
  before do
    @env = ENV["env"]
    ENV["env"] = "development"
  end

  after do
    ENV["env"] = @env || ENV["env"]
  end

  describe "#some_method" do
    it "returns true" do
      STDOUT.should_receive(:puts).with("messagee")
      described_class.write("messagee")
    end
  end
end
