require_relative '../validators/redirect_uri_validator'

module DoorkeeperSequel
  module ApplicationMixin
    extend ActiveSupport::Concern

    include SequelCompat
    include Doorkeeper::OAuth::Helpers
    include Doorkeeper::Models::Scopes
    include DoorkeeperSequel::RedirectUriValidator

    included do
      plugin :validation_helpers
      plugin :timestamps
      plugin :association_dependencies

      one_to_many :access_grants, class: 'Doorkeeper::AccessGrant'
      one_to_many :access_tokens, class: 'Doorkeeper::AccessToken'

      add_association_dependencies access_grants: :delete, access_tokens: :delete

      set_allowed_columns :name, :redirect_uri, :scopes, :confidential

      def before_validation
        generate_uid
        generate_secret
        super
      end

      def validate
        super
        validates_presence [:name, :secret, :uid]
        validates_unique [:uid]
        validates_redirect_uri :redirect_uri
        validates_includes [true, false], :confidential, allow_missing: true

        validate_scopes_match_configured if enforce_scopes?

        if respond_to?(:validate_owner?)
          validates_presence [:owner_id] if validate_owner?
        end
      end

      alias_method :confidential?, :confidential

      protected

      def validate_scopes_match_configured
        if scopes.present? &&
           !Doorkeeper::OAuth::Helpers::ScopeChecker.valid?(scopes.to_s, Doorkeeper.configuration.scopes)

          scope = 'sequel.errors.models.doorkeeper/application.attributes.scopes'
          errors.add(:scopes, I18n.t(:not_match_configured, scope: scope))
        end
      end

      def enforce_scopes?
        Doorkeeper.configuration.enforce_configured_scopes?
      end
    end

    module ClassMethods
      def by_uid_and_secret(uid, secret)
        app = by_uid(uid)
        return unless app
        return app if secret.blank? && !app.confidential?
        return unless app.secret == secret
        app
      end

      def by_uid(uid)
        first(uid: uid.to_s)
      end

      def column_names
        columns.map(&:to_s)
      end
    end

    private

    def has_scopes?
      Doorkeeper::Application.columns.include?('scopes')
    end

    def generate_uid
      self.uid = UniqueToken.generate if uid.blank? && new?
    end

    def generate_secret
      self.secret = UniqueToken.generate if secret.blank? && new?
    end
  end
end
