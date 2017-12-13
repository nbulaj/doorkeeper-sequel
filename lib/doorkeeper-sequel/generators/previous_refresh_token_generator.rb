module DoorkeeperSequel
  class PreviousRefreshTokenGenerator < ::Thor::Group
    include ::Thor::Actions
    include MigrationActions

    source_root File.expand_path('../templates', __FILE__)

    desc 'Support revoke refresh token on access token use'

    def install
      create_migration 'add_previous_refresh_token_to_access_tokens.rb'
    end
  end
end
