require "vito/dsl_file"

describe Vito::DslFile do
  let(:server) { double }

  subject { described_class.new }

  before do
    stub_const("Vito::Dsl::Server", Class.new)
  end

  describe "#run" do
    before do
      Vito::Dsl::Server.stub(:new).with([:hey]) { server }
    end

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
end
