module Doorkeeper
  module Sequel
    module AccessGrantMixin
      extend ActiveSupport::Concern

      include OAuth::Helpers
      include Models::Expirable
      include Models::Revocable
      include Models::Accessible
      include Models::Scopes
      #include ActiveModel::MassAssignmentSecurity if defined?(::ProtectedAttributes)

      included do
        many_to_one :application, class: 'Doorkeeper::Application' #, inverse_of: :access_tokens

        if respond_to?(:set_allowed_columns)
          set_allowed_columns :resource_owner_id, :application_id, :expires_in, :redirect_uri, :scopes
        end

        before_validation :generate_token if new?

        def validate
          super
          validates_presence [:resource_owner_id, :application_id, :token, :expires_in, :redirect_uri]
          validates_unique [:token]
        end
      end

      module ClassMethods
        def by_token(token)
          # TODO: find_by ?
          where(token: token.to_s).limit(1).to_a.first
        end
      end

      private

      def generate_token
        self.token = UniqueToken.generate
      end
    end
  end
end
