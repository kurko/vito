require "vito/core_ext/string"

describe String do
  describe "#camelize" do
    specify "ruby_on_rails returns RubyOnRails" do
      "ruby_on_rails".camelize.should == "RubyOnRails"
    end
  end

  describe "#constantize" do
    specify "'String'.constantize returns String" do
      "String".constantize.should == String
    end

    specify "'Heya'.constantize raises NameError" do
      expect { "Heya".constantize }.to raise_error NameError, "uninitialized constant Heya"
    end
  end
end
