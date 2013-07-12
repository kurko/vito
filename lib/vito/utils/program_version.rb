module Vito
  module Utils
    class ProgramVersion
      def initialize(version_command, connection)
        @version_command = version_command
        @connection = connection
      end

      def matches?(version)
        version = version.gsub(/-/, "(.*){,1}")
        if output.success?
          return output.result =~ /#{version}/
        end
        false
      end

      private

      def output
        @output ||= @connection.query(@version_command)
      end
    end
  end
end
