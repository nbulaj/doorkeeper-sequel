module Doorkeeper
  module Orm
    module Sequel
      module AccessGrantMixin
        extend ActiveSupport::Concern

        include OAuth::Helpers
        include Models::Expirable
        include Models::Revocable
        include Models::Accessible
        include Models::Scopes

        included do
          plugin :validation_helpers
          plugin :timestamps

          many_to_one :application, class: 'Doorkeeper::Application'

          if respond_to?(:set_allowed_columns)
            set_allowed_columns :resource_owner_id, :application_id, :expires_in, :redirect_uri, :scopes
          end

          def before_validation
            generate_token if new?
            super
          end

          def validate
            super
            validates_presence [:resource_owner_id, :application_id, :token, :expires_in, :redirect_uri]
            validates_unique [:token]
          end

          def update_attribute(column, value)
            self[column] = value
            save(columns: [column.to_sym], validate: false)
          end
        end

        module ClassMethods
          def by_token(token)
            find(token: token.to_s)
          end
        end

        private

        def generate_token
          self.token = UniqueToken.generate
        end
      end
    end
  end
end
