module Vito
  module Recipes
    module Apache
      class Service
        def initialize(recipe)
          @recipe = recipe
        end

        def restart


        end

        private

        attr_reader :recipe
      end
    end
  end
end
