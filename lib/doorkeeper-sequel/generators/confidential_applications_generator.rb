module DoorkeeperSequel
  class ConfidentialApplicationsGenerator < ::Thor::Group
    include ::Thor::Actions
    include MigrationActions

    source_root File.expand_path('../templates', __FILE__)

    desc 'Add confidential column to Doorkeeper applications.'

    def install
      create_migration 'add_confidential_to_application_migration'
    end
  end
end
