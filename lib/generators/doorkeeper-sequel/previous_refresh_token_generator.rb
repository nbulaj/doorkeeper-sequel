module DoorkeeperSequel
  class ApplicationOwnerGenerator < ::Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Support revoke refresh token on access token use'

    def install
      copy_file 'add_previous_refresh_token_to_access_tokens.rb', migration_file_name
    end

    private

    def migration_file_name
      "db/migrate/#{migration_timestamp}_add_previous_refresh_token_to_access_tokens.rb"
    end

    def migration_timestamp
      Time.now.strftime('%Y%m%d%H%M%S')
    end
  end
end
