module Vito
  module CommandLine
    class Command
      def initialize(argv)
        @argv = argv
      end

      def run
        Vito::Commands::Run.new(self).perform
      end

      def options
        Vito::CommandLine::Options.new(argv)
      end

      private

      attr_reader :argv
    end
  end
end
