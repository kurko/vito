module Vito
  class Connection
    def initialize(type, args = {})
      @options = {}
      @options[:command] = args[:command]
    end

    def run(command)
      command = command.gsub(/"/, '\"')
      command = command.gsub(/\$\(/, '\$(')
      command = "#{@options[:command]} \"#{command}\""
      Log.write "* Executing: #{command}"

      result = nil
      Bundler.with_clean_env do
        result = system "#{command}"
      end
      result
    end

    private

    attr_reader :options
  end
end
