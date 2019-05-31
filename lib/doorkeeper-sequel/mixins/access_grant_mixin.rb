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
                          :expires_in, :redirect_uri, :scopes, :code_challenge, :code_challenge_method

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
	  
      def plaintext_token
        if secret_strategy.allows_restoring_secrets?
          secret_strategy.restore_secret(self, :token)
        else
          @raw_token
        end
      end
	  
      def update_column(attr, value)
        update(attr => value)
      end
    end

    module ClassMethods
      def by_token(token)
        find_by_plaintext_token(:token, token)
      end
	  
      def find_by(params)
        first(params)
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

      def find_by_plaintext_token(attr, token)
        token = token.to_s

        first(attr => secret_strategy.transform_secret(token)) ||
          find_by_fallback_token(attr, token)
      end
	  
      def find_by_fallback_token(attr, plain_secret)
        return nil unless fallback_secret_strategy

        # Use the previous strategy to look up
        stored_token = fallback_secret_strategy.transform_secret(plain_secret)
        first(attr => stored_token).tap do |resource|
          return nil unless resource

          upgrade_fallback_value resource, attr, plain_secret
        end
      end
	  
      def secret_strategy
        ::Doorkeeper.configuration.token_secret_strategy
      end
      
      def fallback_secret_strategy
        ::Doorkeeper.configuration.token_secret_fallback_strategy
      end
    end
    
    def secret_strategy
      ::Doorkeeper.configuration.token_secret_strategy
    end
      
    def fallback_secret_strategy
      ::Doorkeeper.configuration.token_secret_fallback_strategy
    end
	  
    private
    # Generates token value with UniqueToken class.
    #
    # @return [String] token value
    #
    def generate_token
      @raw_token = UniqueToken.generate
      secret_strategy.store_secret(self, :token, @raw_token)
    end
  end
end