module Vito
  class Installation
    def initialize(requestor)
      @requestor = requestor
    end

    def install

      config[:use].each do |key, value|
        if key == :ruby
          Vito::Recipes::Ruby.new(self).run
        end
      end
    end

  private
    attr_reader :config

    def config
      @config ||= @requestor.config
    end
  end
end
