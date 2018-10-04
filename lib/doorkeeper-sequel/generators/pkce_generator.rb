module DoorkeeperSequel
  class PkceGenerator < ::Thor::Group
    include ::Thor::Actions
    include MigrationActions

    source_root File.expand_path('../templates', __FILE__)

    desc 'Provide support for PKCE.'

    def install
      create_migration 'enable_pkce_migration.rb.erb'
    end
  end
end
