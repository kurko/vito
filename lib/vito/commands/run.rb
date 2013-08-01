module Vito
  module Commands
    class Run
      def initialize(command_line)
        @command_line = command_line
      end

      def perform
        Vito::DslFile.new(command_line).run
      end

      private

      attr_reader :command_line
    end
  end
end
