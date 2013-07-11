require "rubygems"
require "bundler/setup"
require "active_support/inflector"

module Vito
end

Dir["lib/vito/**/*.rb"].each { |f| require f }

