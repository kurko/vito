module Vito
  module CommandLine
    class Options
      include Vito::CommandLine::DocumentFlags

      def initialize(argv)
        @argv = argv
      end

      def file
        file = nil
        argv.each_with_index { |value, index| file = argv[index+1] if file?(value) }
        file
      end

      def available_options
        flags        = self.class.flags
        descriptions = self.class.descriptions
        flags.each_with_index.map { |flag, index| [flag, descriptions[index]] }
      end

      private

      attr_reader :argv

      flag ["-f", "--file"]
      desc "Defines a file"
      def file?(value)
        ["-f", "--file"].include?(value)
      end
    end
  end
end
