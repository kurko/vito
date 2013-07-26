module Vito
  class Log
    def self.write(string, output_to_stdout = true)
      if ENV["env"] != "test"
        puts string if output_to_stdout
      end
    end

    def self.raise(string)
      puts string
    end

    private

    attr_reader :options
  end
end
