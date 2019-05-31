source 'https://rubygems.org'

gemspec

platforms :jruby do
  gem 'jdbc-sqlite3'
end

platforms :ruby, :mswin, :mswin64, :mingw, :x64_mingw do
  gem 'sqlite3'
end

gem 'sequel', '>= 4.0'
gem 'sequel_polymorphic'

gem 'doorkeeper', '>= 4.0.0'
gem 'rails', '~> 5.0'
gem 'bcrypt', '~> 3.1'

group :test do
  gem 'rspec-rails', '~> 3.8'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
