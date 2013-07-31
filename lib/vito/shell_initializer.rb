require "vito/recipes/ruby"

module Vito
  class ShellInitializer
    def initialize(argv = [])
      @argv = argv
    end

    def run
      Vito::DslFile.new(argv).run(vito_file)
    end

    private

    attr_reader :argv

    def vito_file
      file = if argv.empty?
               "vito.rb"
             else
               argv.first
             end
      File.open(file).read
    end
  end
end
