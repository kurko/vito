require "vito/shell_initializer"
require "contracts/vito/installation_contract"

describe Vito::ShellInitializer do
  it_behaves_like "installation contract"

  subject { Vito::ShellInitializer.new(["fixtures/vito.rb"]) }

  describe "#run" do
    let(:recipes) { double }

    before do
      stub_const("Vito::Ssh", Object.new)
    end

    describe "the execution starts" do
      let(:ssh) { double }
      let(:ssh_config) { double(ssh_host: :host, ssh_user: :user) }

      it "connects to the SSH server" do
        subject.stub(:config) { ssh_config }
        subject.stub(:install_recipes)
        subject.stub(:finish_execution)
        Vito::Ssh.stub(:new).with(:host, :user) { ssh }
        subject.run
        subject.ssh.should == ssh
      end
    end

    describe "installation" do
      it "installs the recipes" do
        subject.stub(:start_execution)
        subject.stub(:finish_execution)

        Vito::Installation.stub(:new).with(subject) { recipes }
        recipes.should_receive(:install)

        subject.run
      end
    end

    describe "the execution ends" do
      let(:ssh) { double }

      it "closes the SSH connection" do
        subject.stub(:ssh) { ssh }
        subject.stub(:install_recipes)
        subject.stub(:open_ssh_connection)

        ssh.should_receive(:close)
        subject.run
      end
    end
  end

  describe "#config" do
    it "returns a configuration object" do
      stub_const("Vito::RecipesConfiguration", Object.new)
      Vito::RecipesConfiguration.should_receive(:new) { :config }
      subject.config.should == :config
    end
  end
end
