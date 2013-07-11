require "vito/recipes/git"

describe Vito::Recipes::Git do
  let(:requestor) { double }

  subject { Vito::Recipes::Git.new(requestor) }

end
