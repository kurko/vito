require "vito/tasks/vagrant_bootstrap"

describe Vito::Tasks::VagrantBootstrap do
  subject { described_class.new("ubuntu12") }

  before do
    subject.stub(:system)
    subject.stub(:`)
    STDOUT.stub(:puts)
    Dir.stub(:chdir)
    subject.stub(:snapshot_exist?) { true }
  end

  describe "#install" do
    it "outputs a message about the setup about to start" do
      STDOUT.should_receive(:puts).with(/ubuntu12.*ubuntu12_test_box.*vagrant_boxes\/ubuntu12/)
      subject.install
    end

    it "changes dir to the box one" do
      Dir.stub(:chdir)
      Dir.should_receive(:chdir).with("spec/vagrant_boxes/ubuntu12")
      subject.install
    end

    it "starts the vagrant box and halts it" do
      subject.should_receive(:system).with("vagrant up && vagrant halt")
      subject.install
    end

    describe "snapshot plugin installation" do
      it "installs the snapshot plugin if it's not present" do
        subject.stub(:system) { false }
        subject.should_receive(:system).with("vagrant plugin install vagrant-vbox-snapshot")
        subject.install
      end

      it " doesn't install the snapshot plugin if it's present" do
        subject.stub(:system) { true }
        subject.should_not_receive(:system).with("vagrant plugin install vagrant-vbox-snapshot")
        subject.install
      end
    end

    describe "snapshot creation" do
      it "takes a initial snapshot if none exist" do
        subject.stub(:snapshot_exist?) { false }
        subject.should_receive(:system).with("vagrant snapshot take ubuntu12_initial_box")
        subject.install
      end

      it "doesn't take a initial snapshot if it already exists" do
        subject.stub(:snapshot_exist?) { true }
        subject.should_not_receive(:system).with("vagrant snapshot take ubuntu12_initial_box")
        subject.install
      end
    end

    it "gets back to the original dir" do
      Dir.stub(:pwd) { :original_path }
      Dir.should_receive(:chdir).with(:original_path)
      subject.install
    end
  end
end
