module DoorkeeperSequel
  module AccessGrantMixin
    extend ActiveSupport::Concern

    include SequelCompat
    include Doorkeeper::OAuth::Helpers
    include Doorkeeper::Models::Expirable
    include Doorkeeper::Models::Revocable
    include Doorkeeper::Models::Accessible
    include Doorkeeper::Models::Scopes

    included do
      plugin :validation_helpers
      plugin :timestamps

      many_to_one :application, class: 'Doorkeeper::Application'

      set_allowed_columns :resource_owner_id, :application_id,
                          :expires_in, :redirect_uri, :scopes, :code_challenge,

      def before_validation
        generate_token if new?
        super
      end

      def validate
        super
        validates_presence [:resource_owner_id, :application_id,
                            :token, :expires_in, :redirect_uri]
        validates_unique [:token]
      end

      def uses_pkce?
        pkce_supported? && code_challenge.present?
      end

      def pkce_supported?
        respond_to? :code_challenge
      end
    end

    module ClassMethods
      def by_token(token)
        first(token: token.to_s)
      end

      def revoke_all_for(application_id, resource_owner, clock = Time)
        where(application_id: application_id,
              resource_owner_id: resource_owner.id,
              revoked_at: nil)
          .update(revoked_at: clock.now.utc)
      end

      def generate_code_challenge(code_verifier)
        padded_result = Base64.urlsafe_encode64(Digest::SHA256.digest(code_verifier))
        padded_result.split('=')[0] # Remove any trailing '='
      end

      def pkce_supported?
        new.pkce_supported?
      end
    end

    private

    def generate_token
      self.token = UniqueToken.generate
    end
  end
end
