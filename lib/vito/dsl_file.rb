module Vito
  class DslFile
    def initialize(command_line = nil)
      @command_line = command_line
    end

    def run(string = nil, &block)
      if block_given?
        instance_eval(&block)
      else
        string ||= vito_file
        instance_eval(string)
      end
    end

    private

    attr_reader :command_line

    # called by the vito.rb file
    def server(*args, &block)
      Vito::Dsl::Server.new(args).instance_eval(&block)
    end

    def vito_file
      file = command_line.options.file || "vito.rb"
      File.open(file).read
    end
  end
end
