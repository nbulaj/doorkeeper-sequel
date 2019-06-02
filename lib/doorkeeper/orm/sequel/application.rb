module Doorkeeper
  class Application < Sequel::Model(:oauth_applications)
    include DoorkeeperSequel::ApplicationMixin

    one_to_many :authorized_tokens, class: 'Doorkeeper::AccessToken', conditions: { revoked_at: nil }
    many_to_many :authorized_applications, join_table: :oauth_access_tokens,
                                           class: self, left_key: :id, right_key: :application_id

    def redirect_uri=(uris)
      super(uris.is_a?(Array) ? uris.join("\n") : uris)
    end
	
	def plaintext_secret
      if secret_strategy.allows_restoring_secrets?
        secret_strategy.restore_secret(self, :secret)
      else
        @raw_secret
      end
    end

    def generate_secret
      return unless secret.blank?

      @raw_secret = UniqueToken.generate
      secret_strategy.store_secret(self, :secret, @raw_secret)
    end

    def self.authorized_for(resource_owner)
      resource_access_tokens = AccessToken.active_for(resource_owner)
      where(id: resource_access_tokens.select_map(:application_id)).all
    end

    def self.revoke_tokens_and_grants_for(id, resource_owner)
      AccessToken.revoke_all_for(id, resource_owner)
      AccessGrant.revoke_all_for(id, resource_owner)
    end
  end
end
