require "spec_helper"

describe "Postgres recipe" do
  before do
    setup_vagrant
  end

  it "installs Postgres" do
    assert_installation("psql --version").should be_false

    Vito::DslFile.new.run do
      server do
        connection :ssh, command: 'ssh -i ~/.vagrant.d/insecure_private_key vagrant@localhost -p2222', silent: true
        install :postgres, username: 'sebasoga', password: 'kicks_ass'
      end
    end

    assert_installation("psql --version").should be_true
  end
end
