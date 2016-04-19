$:.push File.expand_path('../lib', __FILE__)

require 'doorkeeper-sequel/version'

Gem::Specification.new do |gem|
  gem.name        = 'doorkeeper-sequel'
  gem.version     = DoorkeeperSequel.gem_version
  gem.authors     = ['Nikita Bulaj']
  gem.date         = '2016-04-19'
  gem.email       = ['bulajnikita@gmail.com']
  gem.homepage    = 'http://github.com/nbulaj/doorkeeper-sequel'
  gem.summary     = 'Doorkeeper Sequel ORM'
  gem.description = gem.summary
  gem.license     = 'MIT'

  gem.require_paths = %w(lib config)
  gem.files = `git ls-files`.split($RS)
  gem.test_files = Dir['spec/**/*']

  gem.required_ruby_version = '>= 2.0.0'

  gem.add_dependency 'doorkeeper', '>= 3.0.0'

  gem.add_development_dependency 'sqlite3', '~> 1.3.5'
  gem.add_development_dependency 'rspec-rails', '~> 3.2.0'
  gem.add_development_dependency 'capybara', '~> 2.3.0'
  gem.add_development_dependency 'generator_spec', '~> 0.9.0'
  gem.add_development_dependency 'factory_girl', '~> 4.5.0'
  gem.add_development_dependency 'timecop', '~> 0.7.0'
  gem.add_development_dependency 'database_cleaner', '~> 1.3.0'
end
