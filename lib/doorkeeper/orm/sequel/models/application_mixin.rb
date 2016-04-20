require_relative '../validators/redirect_uri_validator'

module Doorkeeper
  module Orm
    module Sequel
      module ApplicationMixin
        extend ActiveSupport::Concern

        include OAuth::Helpers
        include Models::Scopes
        include Doorkeeper::Orm::Sequel::RedirectUriValidator

        included do
          plugin :validation_helpers
          plugin :timestamps
          plugin :association_dependencies

          one_to_many :access_grants, class: 'Doorkeeper::AccessGrant'
          one_to_many :access_tokens, class: 'Doorkeeper::AccessToken'

          add_association_dependencies access_grants: :destroy, access_tokens: :destroy

          if respond_to?(:set_allowed_columns)
            set_allowed_columns :name, :redirect_uri, :scopes
          end

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
          end
        end

        module ClassMethods
          def by_uid_and_secret(uid, secret)
            find(uid: uid.to_s, secret: secret.to_s)
          end

          def by_uid(uid)
            find(uid: uid.to_s)
          end
        end

        private

        def has_scopes?
          Doorkeeper.configuration.orm != :active_record ||
              Doorkeeper::Application.columns.include?('scopes')
        end

        def generate_uid
          self.uid = UniqueToken.generate if (uid.blank? && new?)
        end

        def generate_secret
          self.secret = UniqueToken.generate if (secret.blank? && new?)
        end
      end
    end
  end
end
