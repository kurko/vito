require "vito/installation"

shared_examples "installation contract" do
  it "responds to install" do
    recipes = Vito::Installation.new(double("name"), double("options"), double("connection"))
    recipes.should respond_to(:install)
  end
end
