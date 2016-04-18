$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'doorkeeper-sequel/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'doorkeeper-sequel'
  spec.version     = DoorkeeperSequel.gem_version
  spec.authors     = ['Nikita Bulaj']
  spec.email       = ['bulajnikita@gmail.com']
  spec.homepage    = 'http://github.com/nbulaj/doorkeeper-sequel'
  spec.summary     = 'Doorkeeper Sequel ORM'
  spec.description = spec.summary
  spec.license     = 'MIT'

  spec.files = Dir['lib/**/*', 'LICENSE', 'Rakefile', 'README.md']
  spec.test_files = Dir['spec/**/*']

  spec.add_dependency 'doorkeeper', '>= 3.0.0'

  spec.add_development_dependency 'sqlite3', '~> 1.3.5'
  spec.add_development_dependency 'rspec-rails', '~> 3.2.0'
  spec.add_development_dependency 'capybara', '~> 2.3.0'
  spec.add_development_dependency 'generator_spec', '~> 0.9.0'
  spec.add_development_dependency 'factory_girl', '~> 4.5.0'
  spec.add_development_dependency 'timecop', '~> 0.7.0'
  spec.add_development_dependency 'database_cleaner', '~> 1.3.0'
end
