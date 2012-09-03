require "vito/installation"
require "contracts/vito/installation_contract"

describe Vito::Installation do
  it_behaves_like "installation contract"

  let(:config) { {use: {ruby: "1.9.3"}} }
  let(:requestor) { double(config: config) }
  subject { Vito::Installation.new(requestor) }

  describe "#install" do
    before do
      stub_const("Vito::Ssh", Object.new)
      stub_const("Vito::Recipes::Ruby", Object.new)
    end

    it "installs each recipes" do
      ruby = double
      ruby.should_receive(:run)
      Vito::Recipes::Ruby.stub(:new).with(subject) { ruby }

      subject.install
    end
  end
end
