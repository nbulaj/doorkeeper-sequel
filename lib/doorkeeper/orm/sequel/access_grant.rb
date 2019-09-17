module Doorkeeper
  class AccessGrant < Sequel::Model(:oauth_access_grants)
    include DoorkeeperSequel::AccessGrantMixin

    def plaintext_token
      if secret_strategy.allows_restoring_secrets?
        secret_strategy.restore_secret(self, :token)
      else
        @raw_token
      end
    end

    def uses_pkce?
      pkce_supported? && code_challenge.present?
    end

    def pkce_supported?
      respond_to?(:code_challenge)
    end
  end
end
