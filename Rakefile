require 'bundler/setup'
require 'rspec/core/rake_task'

task :copy_and_run_doorkeeper_specs do
  # Copy native Doorkepeer specs
  `cp -r -n doorkeeper/spec .`
  # Replace ORM-independent files (configs, models, etc)
  `cp -rf spec/stubs/models/user.rb spec/dummy/app/models/user.rb`
  `cp -rf spec/stubs/support/sequel.rb spec/support/orm/sequel.rb`
  `cp -rf spec/stubs/initializers/db.rb spec/dummy/config/initializers/db.rb`
  # Run specs
  `bundle exec rspec`
end

desc 'Default: run specs.'
task default: :spec

desc 'Clone doorkeeper specs, prepare it for Sequel and run'
task spec: :copy_and_run_doorkeeper_specs

RSpec::Core::RakeTask.new(:spec) do |config|
  config.verbose = false
end

Bundler::GemHelper.install_tasks
