module Doorkeeper
  module Sequel
    class ApplicationOwnerGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc 'Provide support for client application ownership.'

      def install
        copy_file 'add_owner_to_application.rb', migration_file_name
      end

      private

      def migration_file_name
        "db/migrate/#{migration_timestamp}_add_owner_to_application.rb"
      end

      def migration_timestamp
        Time.now.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end
