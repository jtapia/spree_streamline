# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_product_activator'
  s.version     = '1.0.0'
  s.summary     = 'Spree Product Activator'
  s.description = 'Spree Product Activator Extension'
  s.required_ruby_version = '>= 1.9.3'

  s.author      = ['Jonathan Tapia']
  s.email       = ['jonathan.tapia@crowdint.com']
  s.homepage    = 'http://github.com/jtapia/spree_product_activator'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.2.0'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'shoulda-matchers', '>= 1.5.4'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
