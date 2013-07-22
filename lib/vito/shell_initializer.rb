require "vito/recipes/ruby"

module Vito
  class ShellInitializer
    def initialize(argv)
      @argv = argv
    end

    def run
      Vito::DslFile.new(argv).run(vito_file)
    end

    private

    attr_reader :argv

    def vito_file
      File.open("vito.rb").read
    end
  end
end
