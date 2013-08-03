require "spec_helper"

describe Vito::Recipes::Passenger::Paths do
  let(:recipe) { double }
  let(:result)  { double(result: gemspec_path) }
  let(:gemspec_path) { "/Users/kurko/.rbenv/versions/2.0.0-p195/lib/ruby/gems/2.0.0/gems/passenger-4.0.10/passenger.gemspec\n" }

  subject { described_class.new(recipe) }

  describe "#mod_passenger" do
    context "apache" do
      it "returns the mod_passenger path" do
        recipe.stub(:query).with("gem contents passenger|grep gemspec") { result }
        subject.mod_passenger(:apache).should == "/Users/kurko/.rbenv/versions/2.0.0-p195/lib/ruby/gems/2.0.0/gems/passenger-4.0.10/buildout/apache2/mod_passenger.so"
      end
    end
  end
end
