module Vito
  module CommandLine
    class String
      def initialize(argv)
        @argv = argv
      end

      def run
        "Vito::Commands::#{command.camelize}".constantize.new(self).perform
      end

      # Options are anything that comes after dashes in the command line:
      #
      #   -f filename
      #   --file filename
      #
      def options
        Vito::CommandLine::Options.new(argv)
      end

      # Command is the first part of the command string, if any given:
      #
      #   vito commands
      #
      # In this case, it'll run the `commands` command.
      def command
        Vito::CommandLine::Command.new(self).command
      end

      private

      attr_reader :argv
    end
  end
end
