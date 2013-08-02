require "spec_helper"

describe Vito::Recipes::Ruby do
  let(:options)    { double("options").as_null_object }
  let(:connection) { double("connection").as_null_object }

  subject { Vito::Recipes::Ruby.new(options, connection) }

  before do
    STDOUT.stub(:puts)
    Vito::ConnectionOutput.stub(:write)
  end

  describe "#install" do
    it "installs rbenv" do
      subject.stub(:install_os_dependencies)

      rbenv = double
      rbenv.should_receive(:install)
      Vito::Recipes::Rbenv.stub(:new).with(anything, connection) { rbenv }
      subject.install
    end
  end
end
