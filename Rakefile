require 'bundler/setup'
require 'rspec/core/rake_task'

class ExtensionIntegrator
  class << self
    def init_submodule!
      `git submodule init`
      `git submodule update`
    end

    def clear_specs!
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

    def copy_spec_stubs!
      FileUtils.cp_r('spec/stubs/spec_helper_integration.rb', 'spec/spec_helper_integration.rb')
      FileUtils.cp_r('spec/stubs/models/user.rb', 'spec/dummy/app/models/user.rb')
      FileUtils.cp_r('spec/stubs/config/initializers/db.rb', 'spec/dummy/config/initializers/db.rb')
      FileUtils.cp_r('spec/stubs/config/application.rb', 'spec/dummy/config/application.rb')
      FileUtils.cp_r('spec/stubs/support/sequel.rb', 'spec/support/orm/sequel.rb')
      FileUtils.rm('spec/dummy/config/initializers/active_record_belongs_to_required_by_default.rb')
      # Generators
      FileUtils.rm(Dir.glob('spec/generators/*.rb'))
      FileUtils.cp_r(Dir.glob('spec/stubs/generators/*.rb'), 'spec/generators/')
    end
  end
end

desc 'Update Git submodules.'
task :update_submodules do
  `git submodule foreach git pull origin master`
end

task :copy_and_run_doorkeeper_specs do
  # Clear specs directory
  ExtensionIntegrator.clear_specs!
  # Init Doorkeeper submodel if it doesn't exists
  ExtensionIntegrator.init_submodule! if Dir['doorkeeper/*'].empty?
  # Copy native Doorkepeer specs
  `cp -r -n doorkeeper/spec .`
  # Replace ORM-dependent files (configs, models, etc)
  ExtensionIntegrator.copy_spec_stubs!
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
