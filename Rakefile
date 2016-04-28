require 'bundler/setup'
require 'rspec/core/rake_task'

def clear_specs
  base_dir = File.join(Dir.pwd, 'spec')
  Dir.foreach(base_dir) do |file|
    next if %w(. .. stubs).include?(file)

    file_name = File.join(base_dir, file)
    if File.directory?(file_name)
      FileUtils.rm_rf(file_name)
    else
      File.delete(file_name)
    end
  end
end

task :copy_and_run_doorkeeper_specs do
  # Clear specs dir
  clear_specs
  # Copy native Doorkepeer specs
  `cp -r -n doorkeeper/spec .`
  # Replace ORM-independent files (configs, models, etc)
  FileUtils.cp_r('spec/stubs/spec_helper_integration.rb', 'spec/spec_helper_integration.rb')
  FileUtils.cp_r('spec/stubs/models/user.rb', 'spec/dummy/app/models/user.rb')
  FileUtils.cp_r('spec/stubs/config/initializers/db.rb', 'spec/dummy/config/initializers/db.rb')
  FileUtils.cp_r('spec/stubs/config/application.rb', 'spec/dummy/config/application.rb')
  FileUtils.cp_r('spec/stubs/support/sequel.rb', 'spec/support/orm/sequel.rb')
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
