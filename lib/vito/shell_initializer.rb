require "vito/recipes/ruby"

module Vito
  class ShellInitializer
    attr_reader :ssh

    def initialize(args)
      @installation_specs = File.open("vito.rb").read
    end

    def run
      #start_execution
      run_vito_file
      #finish_execution
    end

    # called by the vito.rb file
    def server(*args, &block)
      Vito::Server.new.instance_eval &block
    end

    def run_ssh(command = nil)
      @ssh.run(command) if command
    end

    private

    def run_vito_file
      instance_eval @installation_specs
    end
  end
end
