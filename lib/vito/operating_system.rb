module Vito
  class OperatingSystem
    def initialize(connection)
      @connection = connection
    end

    def update_packages
      os.update_packages
    end

    def install_dependencies(dependencies)
      os.install_dependencies(dependencies)
    end

    private

    def os
      @os ||= Vito::OperatingSystem::Ubuntu10.new(@connection)
    end
  end
end
