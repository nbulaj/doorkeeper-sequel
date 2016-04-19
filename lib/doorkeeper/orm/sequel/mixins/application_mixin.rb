module Doorkeeper
  module Sequel
    module ApplicationMixin
      extend ActiveSupport::Concern

      include OAuth::Helpers
      include Models::Scopes
      # include ActiveModel::MassAssignmentSecurity if defined?(::ProtectedAttributes)

      included do
        plugin :validation_helpers
        plugin :association_dependencies

        one_to_many :access_grants, class: 'Doorkeeper::AccessGrant'
        one_to_many :access_tokens, class: 'Doorkeeper::AccessToken'

        add_association_dependencies access_grants: :destroy, access_tokens: :destroy

        # TODO: custom validator!
        # validates :redirect_uri, redirect_uri: true

        before_validation :generate_uid, :generate_secret if new?

        if respond_to?(:set_allowed_columns)
          set_allowed_columns :name, :redirect_uri, :scopes
        end

        def validate
          super
          validates_presence [:name, :secret, :uid]
          validates_unique [:uid]
        end
      end

      module ClassMethods
        def by_uid_and_secret(uid, secret)
          # TODO: find_by ?
          where(uid: uid.to_s, secret: secret.to_s).limit(1).to_a.first
        end

        def by_uid(uid)
          # TODO: find_by ?
          where(uid: uid.to_s).limit(1).to_a.first
        end
      end

      private

      # TODO: ???
      def has_scopes?
        Doorkeeper.configuration.orm != :active_record ||
            Application.new.attributes.include?("scopes")
      end

      def generate_uid
        if uid.blank?
          self.uid = UniqueToken.generate
        end
      end

      def generate_secret
        if secret.blank?
          self.secret = UniqueToken.generate
        end
      end
    end
  end
end
