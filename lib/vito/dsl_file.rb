module Vito
  class DslFile
    def initialize(argv = nil)
      @argv = argv
    end

    def run(code_string = nil, &block)
      if block_given?
        instance_eval(&block)
      else
        instance_eval(code_string)
      end
    end

    private

    attr_reader :options

    # called by the vito.rb file
    def server(*args, &block)
      Vito::Dsl::Server.new(args).instance_eval(&block)
    end
  end
end
