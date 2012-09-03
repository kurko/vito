require "vito/recipes/ruby"

describe Vito::Recipes::Ruby do
  let(:vito) { double }

  subject { Vito::Recipes::Ruby.new(vito) }

  before do
    stub_const("Vito::Recipes::Git", Object.new)
    stub_const("Vito::Recipes::Rbenv", Object.new)
    stub_const("Vito::OperatingSystem", Object.new)
    stub_const("Vito::Output", Object.new)
    Vito::Output.stub(:write)
  end

  describe "#run" do
    it "installs the operating system dependencies" do
      subject.stub(:install_git)
      subject.stub(:install_rbenv)

      dependencies = %w( build-essential openssl libreadline6
                         libreadline6-dev zlib1g zlib1g-dev libssl-dev
                         libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3
                         libxml2-dev libxslt1-dev autoconf libc6-dev
                         libncurses5-dev)
      operating_system = double
      operating_system.should_receive(:install_dependencies).with(dependencies)
      Vito::OperatingSystem.stub(:new).with(subject) { operating_system }
      subject.run
    end

    it "installs git" do
      subject.stub(:install_rbenv)
      subject.stub(:install_os_dependencies)

      git = double
      git.should_receive(:run)
      Vito::Recipes::Git.stub(:new).with(subject) { git }
      subject.run
    end

    it "installs rbenv" do
      subject.stub(:install_git)
      subject.stub(:install_os_dependencies)

      rbenv = double
      rbenv.should_receive(:run)
      Vito::Recipes::Rbenv.stub(:new).with(subject) { rbenv }
      subject.run
    end
  end
end
