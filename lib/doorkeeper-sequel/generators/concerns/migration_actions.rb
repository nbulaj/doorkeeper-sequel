module DoorkeeperSequel
  module MigrationActions
    extend ::ActiveSupport::Concern

    protected

    def create_migration(template_name)
      copy_file template_name, migration_filename_for(template_name)
    end

    def migration_template
      File.expand_path('../templates/migration.rb', __FILE__)
    end

    private

    def migration_filename_for(template_name)
      "db/migrate/#{new_migration_number}_#{template_name}"
    end

    def new_migration_number
      current_number = current_migration_number('db/migrate')

      # possible numeric migration
      if current_number && current_number.start_with?('0')
        # generate the same name as used by the developer
        "%.#{current_number.length}d" % (current_number.to_i + 1)
      else
        Time.now.utc.strftime('%Y%m%d%H%M%S')
      end
    end

    def current_migration_number(dirname)
      migration_lookup_at(dirname).collect do |file|
        File.basename(file).split('_').first
      end.max
    end

    def migration_lookup_at(dirname)
      Dir.glob("#{dirname}/[0-9]*_*.rb")
    end
  end
end
