module DoorkeeperSequel
  module AccessTokenMixin
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

      attr_writer :use_refresh_token

      set_allowed_columns :application_id, :resource_owner_id, :expires_in,
                          :scopes, :use_refresh_token, :previous_refresh_token

      def before_validation
        if new?
          generate_token
          generate_refresh_token if use_refresh_token?
        end

        super
      end

      def validate
        super
        validates_presence [:token]
        validates_unique [:token]

        validates_unique [:refresh_token] if use_refresh_token?
      end

      def application_id?
        application_id.present?
      end
	  
      def plaintext_refresh_token
        if secret_strategy.allows_restoring_secrets?
          secret_strategy.restore_secret(self, :refresh_token)
        else
          @raw_refresh_token
        end
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

      def by_refresh_token(refresh_token)
        find_by_plaintext_token(:refresh_token, refresh_token)
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

      def revoke_all_for(application_id, resource_owner, clock = Time)
        where(application_id: application_id,
              resource_owner_id: resource_owner.id,
              revoked_at: nil)
          .update(revoked_at: clock.now.utc)
      end

      def matching_token_for(application, resource_owner_or_id, scopes)
        resource_owner_id = if resource_owner_or_id.respond_to?(:to_key)
                              resource_owner_or_id.id
                            else
                              resource_owner_or_id
                            end
        tokens = authorized_tokens_for(application.try(:id), resource_owner_id)
        tokens.detect do |token|
          scopes_match?(token.scopes, scopes, application.try(:scopes))
        end
      end

      def scopes_match?(token_scopes, param_scopes, app_scopes)
	    scope_checker = Doorkeeper::OAuth::Helpers::ScopeChecker::Validator.new(
          param_scopes.to_s,
          Doorkeeper.configuration.scopes,
          app_scopes,
		  nil
        )
        return true if token_scopes.empty? && param_scopes.empty?
        (token_scopes.sort == param_scopes.sort) && scope_checker.valid?
      end

      def authorized_tokens_for(application_id, resource_owner_id)
        ordered_by(:created_at, :desc).
          where(application_id: application_id,
                resource_owner_id: resource_owner_id,
                revoked_at: nil)
      end

      def find_or_create_for(application, resource_owner_id, scopes, expires_in, use_refresh_token)
        if Doorkeeper.configuration.reuse_access_token
          access_token = matching_token_for(application, resource_owner_id, scopes)
          return access_token if access_token && !access_token.expired?
        end

        create!(
          application_id: application.try(:id),
          resource_owner_id: resource_owner_id,
          scopes: scopes.to_s,
          expires_in: expires_in,
          use_refresh_token: use_refresh_token
        )
      end

      def last_authorized_token_for(application_id, resource_owner_id)
        authorized_tokens_for(application_id, resource_owner_id).first
      end
	  
      def secret_strategy
        ::Doorkeeper.configuration.token_secret_strategy
      end
	  
      def fallback_secret_strategy
        ::Doorkeeper.configuration.token_secret_fallback_strategy
      end
    end

    def token_type
      'Bearer'
    end

    def use_refresh_token?
      !!@use_refresh_token
    end

    def as_json(_options = {})
      {
        resource_owner_id: resource_owner_id,
        scope: scopes,
        expires_in: expires_in_seconds,
        application: { uid: application.try(:uid) },
        created_at: created_at.to_i
      }
    end

    # It indicates whether the tokens have the same credential
    def same_credential?(access_token)
      application_id == access_token.application_id &&
        resource_owner_id == access_token.resource_owner_id
    end

    def acceptable?(scopes)
      accessible? && includes_scope?(*scopes)
    end
	

    private
	
	
	  
    def secret_strategy
      ::Doorkeeper.configuration.token_secret_strategy
    end
	  
    def fallback_secret_strategy
      ::Doorkeeper.configuration.token_secret_fallback_strategy
    end
	
	
    def generate_refresh_token
      @raw_refresh_token = UniqueToken.generate
      secret_strategy.store_secret(self, :refresh_token, @raw_refresh_token)
    end

    def generate_token
      self[:created_at] ||= Time.now.utc

      generator = token_generator
      unless generator.respond_to?(:generate)
        raise Doorkeeper::Errors::UnableToGenerateToken, "#{generator} does not respond to `.generate`."
      end
	  
      @raw_token = generator.generate(
        resource_owner_id: resource_owner_id,
        scopes: scopes,
        application: application,
        expires_in: expires_in,
        created_at: created_at
      )

      secret_strategy.store_secret(self, :token, @raw_token)
    end

    def token_generator
      generator_name = Doorkeeper.configuration.access_token_generator
      generator_name.constantize
    rescue NameError
      raise Doorkeeper::Errors::TokenGeneratorNotFound, "#{generator_name} not found"
    end
  end
end
