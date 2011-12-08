# -*- encoding: utf-8 -*-
require File.expand_path('../lib/api_guides/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Hawkins"]
  gem.email         = ["me@broadcastingadam.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "api_guides"
  gem.require_paths = ["lib"]
  gem.version       = ApiGuides::VERSION

  gem.add_dependency 'mustache'
  gem.add_dependency 'redcarpet', '~> 2.0'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'activesupport', '~> 3.0'
  gem.add_dependency 'i18n'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
end
