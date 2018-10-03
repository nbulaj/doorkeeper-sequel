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

        if respond_to?(:validate_owner?)
          validates_presence [:owner_id] if validate_owner?
        end
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

      def supports_confidentiality?
        column_names.include?('confidential')
      end

      def column_names
        columns.map(&:to_s)
      end
    end

    # Fallback to existing, default behaviour of assuming all apps to be
    # confidential if the migration hasn't been run
    def confidential
      return super if self.class.supports_confidentiality?

      ActiveSupport::Deprecation.warn 'You are susceptible to security bug ' \
        'CVE-2018-1000211. Please follow instructions outlined in ' \
        'Doorkeeper::CVE_2018_1000211_WARNING'

      true
    end

    alias_method :confidential?, :confidential

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
