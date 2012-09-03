require "vito/recipes/ruby"

module Vito
  class ShellInitializer
    attr_reader :ssh

    def initialize(args)
      require args[0]
    end

    def run
      start_execution
      install_recipes
      finish_execution
    end

    def run_ssh(command = nil)
      @ssh.run(command) if command
    end

    def config
      Vito::RecipesConfiguration.new(self)
    end

  private

    def open_ssh_connection
      @ssh ||= Vito::Ssh.new(config.ssh_host, config.ssh_user)
    end

    def start_execution
      open_ssh_connection
    end

    def finish_execution
      ssh.close
    end

    def install_recipes
      Vito::Installation.new(self).install
    end
  end
end
