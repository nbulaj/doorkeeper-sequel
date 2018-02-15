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

      set_allowed_columns :name, :redirect_uri, :scopes

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

        if respond_to?(:validate_owner?)
          validates_presence [:owner_id] if validate_owner?
        end
      end
    end

    module ClassMethods
      def by_uid_and_secret(uid, secret)
        first(uid: uid.to_s, secret: secret.to_s)
      end

      def by_uid(uid)
        first(uid: uid.to_s)
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
