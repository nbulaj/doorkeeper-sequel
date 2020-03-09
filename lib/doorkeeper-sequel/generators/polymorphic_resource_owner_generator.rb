# frozen_string_literal: true

module DoorkeeperSequel
  class PolymorphicResourceOwnerGenerator < ::Thor::Group
    include ::Thor::Actions
    include MigrationActions

    source_root File.expand_path("templates", __dir__)

    desc "Provide support for Polymorphic Resource Owner."

    def install
      create_migration "enable_polymorphic_resource_owner_migration.rb.erb"
    end
  end
end
