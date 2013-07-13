module Vito
  class Recipe
    def initialize(options, connection)
      @options = options
      @connection = connection
    end

    def run
      raise "#{self.class.name} recipe needs to define a #run method"
    end

    def depends_on_recipe(recipe, options = {})
      Installation.new(recipe, options, @connection).install
    end

    def run_command(command)
      @connection.run(command)
    end

    def query(command)
      @connection.query(command)
    end

    # Helper methods
    #
    # should be extracted later
    def program_version(version_command)
      Vito::Utils::ProgramVersion.new(version_command, @connection)
    end

    private

    def os
      @os ||= Vito::OperatingSystem.new(@connection).os
    end

    def install_os_dependencies
      os.update_packages
      os.install_dependencies(os_dependencies) if self.respond_to?(:os_dependencies)
    end
  end
end
