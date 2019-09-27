# frozen_string_literal: true

module DoorkeeperSequel
  class MigrationGenerator < ::Thor::Group
    include ::Thor::Actions
    include MigrationActions

    source_root File.expand_path("templates", __dir__)

    desc "Installs Doorkeeper Sequel migration file."

    def install
      create_migration "create_doorkeeper_tables.rb"
    end
  end
end
