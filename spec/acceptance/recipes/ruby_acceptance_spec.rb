require "spec_helper"

describe "Ruby recipe" do
  before do
    setup_vagrant
  end

  it "installs Git, Rbenv and then Ruby" do
    assert_installation("git --version").should be_false
    assert_installation("rbenv --version").should be_false
    assert_installation("ruby -v").should be_false

    Vito::DslFile.new.run do
      server do
        connection :ssh, command: 'ssh -i ~/.vagrant.d/insecure_private_key vagrant@localhost -p2222', silent: true
        install :ruby, version: "1.9.3-p125"
      end
    end

    assert_installation("git --version").should be_true
    assert_installation("rbenv --version").should be_true
    assert_installation("ruby -v").should be_true
  end
end
