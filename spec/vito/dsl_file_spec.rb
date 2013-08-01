require "vito/dsl_file"

describe Vito::DslFile do
  let(:server) { double }
  let(:passed_in_file) { nil }
  let(:command_line) { double(options: double(file: passed_in_file)) }

  subject { described_class.new(command_line) }

  before do
    stub_const("Vito::Dsl::Server", Class.new)
  end

  describe "#run" do
    before do
      Vito::Dsl::Server.stub(:new).with([:hey]) { server }
    end

    describe "block operation" do
      it "runs the server block evaluating it as string" do
        server.should_receive(:instance_eval)

        subject.run <<-str
          server :hey do

          end
        str
      end

      it "runs the server as a Ruby block" do
        server.should_receive(:instance_eval)

        subject.run do
          server :hey do

          end
        end
      end
    end

    describe "reading the vito file" do
      context "default vito.rb file" do
        let(:passed_in_file) { nil }

        it "uses vito.rb file" do
          File.should_receive(:open).with("vito.rb") { double(read: "") }
          subject.run
        end
      end

      context "custom DSL file" do
        let(:passed_in_file) { "some_file.rb" }

        it "uses some_file.rb file" do
          File.should_receive(:open).with("some_file.rb") { double(read: "") }
          subject.run
        end
      end
    end
  end
end
