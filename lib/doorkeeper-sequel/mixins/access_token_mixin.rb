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
    end

    module ClassMethods
      def by_token(token)
        first(token: token.to_s)
      end

      def by_refresh_token(refresh_token)
        first(refresh_token: refresh_token.to_s)
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
        return true if token_scopes.empty? && param_scopes.empty?
        (token_scopes.sort == param_scopes.sort) &&
          Doorkeeper::OAuth::Helpers::ScopeChecker.valid?(
            param_scopes.to_s,
            Doorkeeper.configuration.scopes,
            app_scopes
          )
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

    def generate_refresh_token
      self[:refresh_token] = UniqueToken.generate
    end

    def generate_token
      self[:created_at] ||= Time.now.utc

      generator = token_generator
      unless generator.respond_to?(:generate)
        raise Doorkeeper::Errors::UnableToGenerateToken, "#{generator} does not respond to `.generate`."
      end

      self[:token] = generator.generate(
        resource_owner_id: resource_owner_id,
        scopes: scopes,
        application: application,
        expires_in: expires_in,
        created_at: created_at
      )
    end

    def token_generator
      generator_name = Doorkeeper.configuration.access_token_generator
      generator_name.constantize
    rescue NameError
      raise Doorkeeper::Errors::TokenGeneratorNotFound, "#{generator_name} not found"
    end
  end
end