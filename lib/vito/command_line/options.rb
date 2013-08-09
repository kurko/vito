require "vito/command_line/document_flags"

module Vito
  module CommandLine
    class Options
      include Vito::CommandLine::DocumentFlags

      def initialize(argv)
        @argv = argv
      end

      flag ["-f", "--file filename"]
      desc "Defines a file"
      def file
        file = nil
        argv.each_with_index { |value, index| file = argv[index+1] if file?(value) }
        file
      end

      flag ["-h", "--help"]
      desc "Shows this documentation"
      def help
        argv.any? { |a| ["-h", "--help"].include?(a) }
      end

      def available_options
        flags        = self.class.flags
        descriptions = self.class.descriptions
        flags.each_with_index.map { |flag, index| [flag, descriptions[index]] }
      end

      private

      attr_reader :argv

      def file?(value)
        ["-f", "--file"].include?(value)
      end
    end
  end
end
