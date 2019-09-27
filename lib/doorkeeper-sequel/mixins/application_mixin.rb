require_relative "../validators/redirect_uri_validator"

module DoorkeeperSequel
  module ApplicationMixin
    extend ActiveSupport::Concern

    include SequelCompat
    include Doorkeeper::OAuth::Helpers
    include Doorkeeper::Models::Scopes
    include Doorkeeper::Models::SecretStorable
    include DoorkeeperSequel::RedirectUriValidator

    included do
      plugin :validation_helpers
      plugin :timestamps
      plugin :association_dependencies

      one_to_many :access_grants, class: "Doorkeeper::AccessGrant"
      one_to_many :access_tokens, class: "Doorkeeper::AccessToken"

      add_association_dependencies access_grants: :delete, access_tokens: :delete

      set_allowed_columns :name, :redirect_uri, :scopes, :confidential

      def before_validation
        if new?
          generate_uid
          generate_secret
        end
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

      # In some cases, Doorkeeper used as a proxy app. In this case database does not have any fields.
      # Even table may not exists on source database.
      # Aliasing this method throws NoMethod Error. Due to this we need to explicitly
      # define confidential? here.
      def confidential?
        confidential.present? && !!confidential
      end

      protected

      def validate_scopes_match_configured
        if scopes.present? && !Doorkeeper::OAuth::Helpers::ScopeChecker.valid?(scope_str: scopes.to_s,
                                                                               server_scopes: Doorkeeper.configuration.scopes)
          scope = "sequel.errors.models.doorkeeper/application.attributes.scopes"
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
        return unless app.secret_matches?(secret)
        app
      end

      def by_uid(uid)
        first(uid: uid.to_s)
      end

      def find_by(params)
        first(params)
      end

      def column_names
        columns.map(&:to_s)
      end

      def secret_strategy
        ::Doorkeeper.configuration.application_secret_strategy
      end

      def fallback_secret_strategy
        ::Doorkeeper.configuration.application_secret_fallback_strategy
      end
    end

    def secret_matches?(input)
      # return false if either is nil, since secure_compare depends on strings
      # but Application secrets MAY be nil depending on confidentiality.
      return false if input.nil? || secret.nil?

      # When matching the secret by comparer function, all is well.
      return true if secret_strategy.secret_matches?(input, secret)

      # When fallback lookup is enabled, ensure applications
      # with plain secrets can still be found
      if fallback_secret_strategy
        fallback_secret_strategy.secret_matches?(input, secret)
      else
        false
      end
    end

    private

    def has_scopes?
      Doorkeeper::Application.columns.include?("scopes")
    end

    def generate_uid
      self.uid = UniqueToken.generate if uid.blank? && new?
    end

    def generate_secret
      return unless secret.blank?

      @raw_secret = UniqueToken.generate
      secret_strategy.store_secret(self, :secret, @raw_secret)
    end
  end
end
