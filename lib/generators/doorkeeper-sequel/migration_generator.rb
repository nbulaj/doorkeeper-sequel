module DoorkeeperSequel
  class MigrationGenerator < ::Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Installs Doorkeeper Sequel migration file.'

    def install
      copy_file 'migration.rb', migration_file_name
    end

    private

    def migration_file_name
      "db/migrate/#{migration_timestamp}_create_doorkeeper_tables.rb"
    end

    def migration_timestamp
      Time.now.strftime('%Y%m%d%H%M%S')
    end
  end
end
