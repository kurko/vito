module Vito
  module OperatingSystems
    class Ubuntu10
      NAME = :ubuntu
      VERSION = "10"

      def initialize(connection)
        @connection = connection
      end

      def is?(name, version = nil)
        version = VERSION unless version
        name == NAME && version.to_s == VERSION
      end

      def update_packages
        @connection.run("sudo apt-get update")
      end

      def install_dependencies(dependencies)
        @connection.run("sudo apt-get install -y #{dependencies.join(" ")}")
      end

      private

      def version
        10
      end
    end
  end
end
