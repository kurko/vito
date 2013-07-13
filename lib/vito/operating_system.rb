module Vito
  class OperatingSystem
    def initialize(connection)
      @connection = connection
    end

    def os
      @os ||= Vito::OperatingSystems::Ubuntu10.new(@connection)
    end
  end
end
