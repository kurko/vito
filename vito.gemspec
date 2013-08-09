# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vito/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexandre de Oliveira"]
  gem.email         = ["chavedomundo@gmail.com"]
  gem.description   = %q{Vito installs webservers for you very easily. Its goal is to be opinionated, with a shallow learning curve needed due to the use of a Gemfile-like specification file.}
  gem.summary       = %q{Install webserver environments automatically in an easier way}
  gem.homepage      = "http://github.com/kurko/vito"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vito"
  gem.license       = "MIT"
  gem.require_paths = ["lib"]
  gem.version       = Vito::VERSION

  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("pry-debugger")
end
