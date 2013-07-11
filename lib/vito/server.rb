module Vito
  class Server
    def new

    end

    def connection(type, options = {})
      @connection ||= Vito::Connection.new(type, options)
    end

    def install(name, options = {})
      Vito::Installation.new(name, options, @connection).install
    end
  end
end
