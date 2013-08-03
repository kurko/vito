module Vito
  module Dsl
    class Installation
      def initialize(name, options, connection)
        @name = name.to_s
        @options = options
        @connection = connection
      end

      def install(&block)
        klass = "Vito::Recipes::#{@name.camelize}::Install".constantize
        recipe = klass.new(@options, @connection)
        recipe.instance_eval(&block) if block_given?
        recipe.install
      end
    end
  end
end
