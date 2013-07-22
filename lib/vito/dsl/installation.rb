module Vito
  module Dsl
    class Installation
      def initialize(name, options, connection)
        @name = name.to_s
        @options = options
        @connection = connection
      end

      def install
        "Vito::Recipes::#{@name.camelize}".constantize.new(@options, @connection).run
      end
    end
  end
end
