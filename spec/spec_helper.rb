ENV["env"] ||= "test"
$:.unshift File.expand_path('../../lib', __FILE__)
require "rubygems"
require "bundler/setup"
require "open3"
require "vito"

Dir["./spec/support/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include RSpecSupport::Vagrant
end
