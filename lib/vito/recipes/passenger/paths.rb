module Vito
  module Recipes
    module Passenger
      class Paths
        def initialize(recipe)
          @recipe = recipe
        end

        def passenger_path
          @passenger_path ||= recipe.query("gem contents passenger|grep gemspec")
            .result
            .gsub(/\n/, "")
            .gsub(/\/passenger\.gemspec/, "")
        end

        def mod_passenger(server = :apache)
          server = "apache2" if server == :apache
          "#{passenger_path}/buildout/#{server}/mod_passenger.so"
        end

        private

        attr_reader :recipe
      end
    end
  end
end
