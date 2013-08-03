module Vito
  module Recipes
    module Ruby
      class Paths
        def initialize(recipe)
          @recipe = recipe
        end

        def ruby_path
          @path ||= recipe.query("rbenv which ruby").result.gsub(/\n/, "")
        end

        private

        attr_reader :recipe
      end
    end
  end
end
