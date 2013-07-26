require "open3"

module Vito
  class Connection
    def initialize(type, args = {})
      @options = {}
      @options[:command] = args[:command]
      @options[:verbose] = args[:verbose] || false
      @options[:silent]  = args[:silent]  || false
    end

    def query(command)
      command = final_command(command)
      execute_command(command)
    end

    def run(command)
      command = final_command(command)
      Log.write("* Executing: #{command}") unless silent?
      output = execute_command(command)

      Log.write(output.result, verbose?)
      unless output.success?
        Log.raise "An error occurred. Here's the stacktrace:"
        Log.raise output.result
        Log.raise ""
        raise "Error."
      end

      output
    end

    private

    attr_reader :options

    def verbose?
      @options[:verbose]
    end

    def silent?
      @options[:silent]
    end

    def execute_command(command)
      stdin, stdout, stderr, thread = []
      # In case we're in development and running `vagrant ssh -c`
      #Bundler.with_clean_env do
      stdin, stdout, stderr, thread = Open3.popen3(command)
      #end
      Vito::ConnectionOutput.new(stdin, stdout, stderr, thread)
    end

    def final_command(command)
      command = command.gsub(/"/, '\"')
      command = command.gsub(/\$\(/, '\$(')
      command = "#{@options[:command]} \"#{command}\""
    end
  end
end
