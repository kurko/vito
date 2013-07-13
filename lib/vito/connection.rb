require "open3"

module Vito
  class Connection
    def initialize(type, args = {})
      @options = {}
      @options[:command] = args[:command]
    end

    def query(command)
      command = final_command(command)
      execute_command(command)
    end

    def run(command)
      command = final_command(command)
      Log.write "* Executing: #{command}"
      output = execute_command(command)

      Log.write output.result
      unless output.success?
        Log.write "An error occurred. Here's the stacktrace:"
        Log.write output.result
        Log.write ""
        raise "Error."
      end

      output
    end

    class Output
      def initialize(stdin, stdout, stderr, thread)
        @stdout = stdout
        @stderr = stderr
        @thread = thread.value
      end

      def success?
        @thread.exitstatus == 0
      end

      def result
        if success?
          @stdout.read
        else
          @stderr.read
        end
      end
    end

    private

    attr_reader :options

    def execute_command(command)
      stdin, stdout, stderr, thread = []
      Bundler.with_clean_env do
        stdin, stdout, stderr, thread = Open3.popen3(command)
      end
      Output.new(stdin, stdout, stderr, thread)
    end

    def final_command(command)
      command = command.gsub(/"/, '\"')
      command = command.gsub(/\$\(/, '\$(')
      command = "#{@options[:command]} \"#{command}\""
    end
  end
end
