require "spec_helper"

describe Vito::Tests::VagrantTestBox do
  let(:os_name) { "ubuntu10" }

  subject { described_class.new(os_name) }

  describe ".boxes" do
    context "no custom box names passed in" do
      it "returns class instances for each box" do
        described_class.boxes.any? { |b| b.name == "centos63" }.should be_true
        described_class.boxes.any? { |b| b.name == "ubuntu10" }.should be_true
        described_class.boxes.any? { |b| b.name == "ubuntu12" }.should be_true
      end
    end

    context "custom box names passed in" do
      it "returns class instances for each box" do
        described_class.boxes(:ubuntu10, :ubuntu12).any? { |b| b.name == "ubuntu12" }.should be_true
        described_class.boxes(:ubuntu10, :ubuntu12).any? { |b| b.name == "ubuntu10" }.should be_true
        described_class.boxes(:ubuntu10, :ubuntu12).any? { |b| b.name == "centos63" }.should be_false
        described_class.boxes(:ubuntu10).any? { |b| b.name == "ubuntu10" }.should be_true
        described_class.boxes(:ubuntu10).any? { |b| b.name == "centos63" }.should be_false
        described_class.boxes(:ubuntu10).any? { |b| b.name == "ubuntu12" }.should be_false
      end
    end
  end

  describe "#ssh_port" do
    context "ubuntu10" do
      let(:os_name) { "ubuntu10" }
      its(:ssh_port) { should == "2223" }
    end

    context "ubuntu12" do
      let(:os_name) { "ubuntu12" }
      its(:ssh_port) { should == "2224" }
    end

    context "centos63" do
      let(:os_name) { "centos63" }
      its(:ssh_port) { should == "2225" }
    end
  end

  describe "#path" do
    context "ubuntu10" do
      let(:os_name) { "ubuntu10" }
      its(:path) { should == "spec/vagrant_boxes/ubuntu10" }
    end

    context "ubuntu12" do
      let(:os_name) { "ubuntu12" }
      its(:path) { should == "spec/vagrant_boxes/ubuntu12" }
    end
  end

  describe "#initial_snapshot_name" do
    context "ubuntu10" do
      let(:os_name) { "ubuntu10" }
      its(:initial_snapshot_name) { should == "ubuntu10_initial_box" }
    end

    context "ubuntu12" do
      let(:os_name) { "ubuntu12" }
      its(:initial_snapshot_name) { should == "ubuntu12_initial_box" }
    end
  end
end
