require "spec_helper"

describe Vito::Recipes::Apache::Install do
  let(:options) { {} }
  let(:connection) { double }
  let(:os) { double.as_null_object }

  subject { described_class.new(options, connection) }

  before do
    subject.stub(:query)
    subject.stub(:system)
    subject.stub(:run_command)
    subject.stub(:depends_on_recipe)
    #STDOUT.stub(:puts)
    Vito::Log.stub(:write)

    Vito::OperatingSystem.stub_chain(:new, :os) { os }
  end

  describe "#install" do
    context "no vhosts or dependency package (with) defined" do
      after do
        subject.install
      end

      it "installs os dependencies" do
        subject.should_receive(:install_os_dependencies)
      end

      it "install apache2-mpm-prefork" do
        subject.should_receive(:run_command).with(/sudo.*apt-get.*apache2-mpm-prefork/i)
      end

      it "doesn't install passenger" do
        subject.should_not_receive(:depends_on_recipe)
      end

      it "disables 000-default site" do
        subject.should_receive(:run_command).with("sudo a2dissite 000-default")
      end

      it "doesn't set up vhosts" do
        Vito::Log.should_not_receive(:write).with(/setting.*hosts/i)
      end

      it "restarts the Apache2 service" do
        os.should_receive(:service).with(:apache2, :restart)
      end
    end

    context "vhosts and with(:passenger) defined" do
      before do
        subject.with :passenger
        subject.vhosts with: :ssl, path: "/var/projects"
      end

      it "installs os dependencies" do
        subject.should_receive(:install_os_dependencies)
        subject.install
      end

      it "install apache2-mpm-prefork" do
        subject.should_receive(:run_command).with(/sudo.*apt-get.*apache2-mpm-prefork/i)
        subject.install
      end

      it "installs passenger" do
        subject.should_receive(:depends_on_recipe).with(:passenger, {server: :apache})
        subject.install
      end

      it "disables 000-default site" do
        subject.should_receive(:run_command).with("sudo a2dissite 000-default")
        subject.install
      end

      describe "setting up vhosts" do
        it "starts setting up vhosts" do
          Vito::Log.should_receive(:write).with(/setting.*hosts/i)
          subject.install
        end

        it "downloads the correct file" do
          subject.should_receive(:run_command).with(/curl.*github.*templates.*vito_rails_site/i)
          subject.install
        end

        it "replaces VITO_PORT" do
          subject.should_receive(:run_command).with(/sed.*VITO_PORT/i)
          subject.install
        end

        it "replaces VITO_SERVERNAME" do
          subject.should_receive(:run_command).with(/sed.*VITO_SERVERNAME/i)
          subject.install
        end

        it "replaces VITO_RAILS_PUBLIC_PATH" do
          subject.should_receive(:run_command).with(/sed.*VITO_RAILS_PUBLIC_PATH/i)
          subject.install
        end

        it "replaces VITO_RAILS_ENV" do
          subject.should_receive(:run_command).with(/sed.*VITO_RAILS_ENV/i)
          subject.install
        end
      end

      it "defines the user for the project dir" do
        subject.should_receive(:run_command).with(/\[ -d \/var\/projects.*|| sudo mkdir/i)
        subject.install
      end

      it "defines the user for the project dir" do
        subject.should_receive(:run_command).with(/sudo chown \\\$USER:admin/i)
        subject.install
      end

      it "activates port 80 vhosts" do
        subject.should_receive(:run_command).with(/sudo a2ensite vito_rails_site_80/i)
        subject.install
      end

      it "restarts the Apache2 service" do
        os.should_receive(:service).with(:apache2, :restart)
        subject.install
      end
    end
  end
end
