module Vito
  class OperatingSystem
    def initialize(connection)
      @connection = connection
    end

    def update_packages
      @connection.run("sudo apt-get update")
    end

    def install_dependencies(dependencies)
      @connection.run("sudo apt-get install -y #{dependencies.join(" ")}")
    end
  end
end
