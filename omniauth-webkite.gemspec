# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/lib/omniauth/webkite/version'

Gem::Specification.new do |gem|
  gem.name        = 'omniauth-webkite'
  gem.version     = OmniAuth::Webkite::VERSION
  gem.authors     = [ 'Greg Gates' ]
  gem.email       = 'greg@webkite.com'
  gem.summary     = 'WebKite strategy for OmniAuth'
  gem.licenses    = ['MIT']

  gem.files = Dir["{lib}/**/*"] + ["Rakefile", "README.rdoc"]
  gem.test_files = Dir["spec/*"]
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'omniauth', '~> 1.1'
  gem.add_runtime_dependency 'omniauth-oauth2', '~> 1.1'
  gem.add_development_dependency 'rake', '~> 10'
  gem.add_development_dependency 'rspec', '~> 2.14'
end
