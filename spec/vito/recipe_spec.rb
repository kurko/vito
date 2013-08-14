require "spec_helper"

class DummyRecipe < Vito::Recipe
end

describe DummyRecipe do
  let(:operating_system) { double }
  let(:options)          { double }
  let(:connection)       { double }

  subject { described_class.new(options, connection) }

  describe "#with" do
    context "with a package specified" do
      before do
        subject.with(:passenger, version: "2.1")
      end

      describe "dynamic methods generated" do
        it "generates a dynamic method with the same name of the package" do
          subject.passenger.should == { version: "2.1" }
        end
      end
    end

    context "with no package specified" do
      it "raises error on package name that wasn't specified" do
        expect { subject.passenger }.to raise_error
      end
    end
  end

  describe "#with?" do
    context "with a package specified" do
      before { subject.with(:passenger, version: "2.1") }

      it "returns true for that package" do
        subject.with?(:passenger).should be_true
      end

      it "returns false for other packages" do
        subject.with?(:packagex).should be_false
      end
    end

    it "returns false when no package is specified" do
      subject.with?(:packagex).should be_false
    end
  end

  describe "#install" do
    it "raises an error if undefined" do
      expect { subject.install }.to raise_error "DummyRecipe recipe needs to define a #install method"
    end
  end

  describe "#remove" do
    it "raises an error if undefined" do
      expect { subject.remove }.to raise_error "DummyRecipe recipe needs to define a #remove method"
    end
  end

  describe "#update" do
    it "raises an error if undefined" do
      expect { subject.update }.to raise_error "DummyRecipe recipe needs to define a #update method"
    end
  end

  describe "#install_os_dependencies" do
    it "installs operating system dependencies" do
      dependencies = %w(build-essential openssl libreadline6
                        libreadline6-dev zlib1g zlib1g-dev libssl-dev
                        libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3
                        libxml2-dev libxslt1-dev autoconf libc6-dev
                        libncurses5-dev)
      subject.stub(:os_dependencies) { dependencies }

      operating_system.should_receive(:update_packages)
      operating_system.should_receive(:install_dependencies).with(dependencies)
      Vito::OperatingSystem.stub(:new).with(connection) { double(os: operating_system) }

      subject.install_os_dependencies(dependencies)
    end
  end

  describe "#depends_on_recipe" do
    it "installs other recipes" do
      Vito::Dsl::Installation
        .stub(:new)
        .with(:ruby, :options, connection)
        .and_return(double(install: :installed))

      subject.depends_on_recipe(:ruby, :options).should == :installed
    end
  end

  describe "#run_command" do
    it "runs a command in the server" do
      connection.should_receive(:run).with(:command) { :result }
      subject.run_command(:command).should == :result
    end
  end

  describe "#query" do
    it "runs a command in the server just querying some information" do
      connection.should_receive(:query).with(:command) { :result }
      subject.query(:command).should == :result
    end
  end

  describe "#program_version" do
    it "checks a given program's version" do
      Vito::Utils::ProgramVersion
        .stub(:new)
        .with("ruby -c", connection)
        .and_return(:truthy)

      subject.program_version("ruby -c").should == :truthy
    end
  end

  describe "#os" do
    it "returns the current OS object" do
      Vito::OperatingSystem.stub(:new).with(connection).and_return(double(os: :os))
      subject.os.should == :os
    end
  end
end
