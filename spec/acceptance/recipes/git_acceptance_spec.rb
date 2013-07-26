require "spec_helper"

describe "Git recipe" do
  before do
    setup_vagrant
  end

  it "installs Git" do
    assert_installation("git --version").should be_false

    Vito::DslFile.new.run do
      server do
        connection :ssh, command: 'ssh -i ~/.vagrant.d/insecure_private_key vagrant@localhost -p2222', silent: true
        install :git
      end
    end

    assert_installation("git --version").should be_true
  end
end
