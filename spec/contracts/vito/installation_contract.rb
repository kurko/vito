require "vito/installation"

shared_examples "installation contract" do
  it "responds to install" do
    recipes = Vito::Installation.new(double)
    recipes.should respond_to(:install)
  end
end
