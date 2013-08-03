module Vito
  module CommandLine
    class Command
      def initialize(command_line)
        @command_line = command_line
      end

      def command
        if command_line.options.help
          "help"
        else
          "install"
        end
      end

      private

      attr_reader :command_line
    end
  end
end
