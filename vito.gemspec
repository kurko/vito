# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vito/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexandre de Oliveira"]
  gem.email         = ["chavedomundo@gmail.com"]
  gem.description   = %q{No description yet}
  gem.summary       = %q{No description yet}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vito"
  gem.require_paths = ["lib"]
  gem.version       = Vito::VERSION

  gem.add_development_dependency("rspec")
end
