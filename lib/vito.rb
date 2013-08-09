require "rubygems"
require "bundler/setup"

module Vito
  class Recipe; end

  module OperatingSystems
    class Unix; end
  end
end

current_path = File.expand_path("../", __FILE__)
Dir["#{current_path}/vito/**/*.rb"].each { |f| require f }
