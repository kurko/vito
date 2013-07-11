module Vito
  class Recipe
    def initialize(options, connection)
      @options = options
      @connection = connection
    end

    def run
      raise "#{self.class.name} recipe needs to define a #run method"
    end

    def install_recipe(recipe, options = {})
      Installation.new(recipe, options, @connection).install
    end

    def run_command(command)
      @connection.run(command)
    end

    private

    def install_os_dependencies
      os = Vito::OperatingSystem.new(@connection)
      os.update_packages
      os.install_dependencies(os_dependencies) if self.respond_to?(:os_dependencies)
    end
  end
end
