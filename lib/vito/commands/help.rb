module Vito
  module Commands
    class Help
      def initialize(command_line)
        @command_line = command_line
      end

      def perform
        output = ""

        output << "Usage: vito [COMMAND] [OPTIONS]\n"
        output << "\n"
        output << "Options:\n"
        output << "\n"

        available_options.each do |option|
          output << "\s\s"
          output << option[0].join(", ")
          output << ("\s" * tabs_needed_for_flags(option[0]))
          output << "\s\s"
          output << option[1]
          output << "\n"
        end

        puts output
      end

      private

      attr_reader :command_line

      def available_options
        command_line.options.available_options
      end

      def tabs_needed_for_flags(option)
        longer_option - count_flags_chars(option)
      end

      def longer_option
        max_chars = 0
        flags.each do |option|
          options_flags_chars = count_flags_chars(option)
          max_chars = options_flags_chars if options_flags_chars > max_chars
        end
        max_chars
      end

      def flags
        available_options.map { |o| o[0] }
      end

      def count_flags_chars(option)
        total_chars = 0
        option.each do |flag|
          total_chars+= flag.size
        end
        total_chars
      end
    end
  end
end
