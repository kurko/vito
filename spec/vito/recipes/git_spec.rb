require "spec_helper"

describe Vito::Recipes::Git do
  let(:requestor) { double }

  subject { Vito::Recipes::Git.new(requestor) }

end
