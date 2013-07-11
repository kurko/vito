module Vito
  class Log
    def self.write(string)
      puts string
    end

    private

    attr_reader :options
  end
end
