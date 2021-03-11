# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "doorkeeper-sequel/version"

Gem::Specification.new do |gem|
  gem.name = "doorkeeper-sequel"
  gem.version = DoorkeeperSequel.gem_version
  gem.authors = ["Nikita Bulai"]
  gem.email = ["bulajnikita@gmail.com"]
  gem.homepage = "http://github.com/nbulaj/doorkeeper-sequel"
  gem.summary = "Doorkeeper Sequel ORM"
  gem.description = "Provides Doorkeeper support to Sequel database toolkit."
  gem.license = "MIT"

  gem.bindir = "bin"
  gem.require_paths = %w[lib config]
  gem.files = `git ls-files`.split($RS)
  gem.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.test_files = Dir["spec/**/*"]

  gem.required_ruby_version = ">= 2.0.0"

  gem.add_runtime_dependency "bcrypt", "~> 3.1"
  gem.add_runtime_dependency "doorkeeper", ">= 5.0.0", "< 5.6"
  gem.add_runtime_dependency "sequel", ">= 4.0.0", "< 6"
  gem.add_runtime_dependency "sequel_polymorphic", "~> 0.2", "< 1.0"
  gem.add_runtime_dependency "thor", ">= 0.18", "< 6"

  gem.add_development_dependency "capybara", "~> 2.14", ">= 2.14.0"
  gem.add_development_dependency "coveralls"
  gem.add_development_dependency "database_cleaner", "~> 1.5", ">= 1.5.0"
  gem.add_development_dependency "factory_bot", "~> 4.8"
  gem.add_development_dependency "generator_spec", "~> 0.9.4"
  gem.add_development_dependency "grape"
  gem.add_development_dependency "rspec-rails", "~> 3.5"
end
