module Vito
  module Dsl
    class Server
      def initialize(args = [])
        @args = args
      end

      def connection(type, options = {})
        @connection ||= Vito::Connection.new(type, options)
      end

      def install(name, options = {}, &block)
        Vito::Dsl::Installation.new(name, options, @connection).install(&block)
      end
    end
  end
end
