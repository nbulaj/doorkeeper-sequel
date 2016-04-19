module Doorkeeper
  module Orm
    module Sequel
      module AccessTokenMixin
        extend ActiveSupport::Concern

        include OAuth::Helpers
        include Models::Expirable
        include Models::Revocable
        include Models::Accessible
        include Models::Scopes

        included do
          plugin :validation_helpers
          plugin :timestamps

          one_to_many :application, class: 'Doorkeeper::Application'

          attr_writer :use_refresh_token

          if respond_to?(:set_allowed_columns)
            set_allowed_columns :application_id, :resource_owner_id, :expires_in,
                                :scopes, :use_refresh_token
          end

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

          def update_attribute(column, value)
            set(column.to_sym => value)
            save(columns: [column.to_sym], validate: false)
          end
        end

        # TODO: review code above
        module ClassMethods
          def by_token(token)
            find(token: token.to_s)
          end

          def by_refresh_token(refresh_token)
            find(refresh_token: refresh_token.to_s)
          end

          def revoke_all_for(application_id, resource_owner)
            where(application_id: application_id,
                  resource_owner_id: resource_owner.id,
                  revoked_at: nil).
                map(&:revoke)
          end

          def matching_token_for(application, resource_owner_or_id, scopes)
            resource_owner_id = if resource_owner_or_id.respond_to?(:to_key)
                                  resource_owner_or_id.id
                                else
                                  resource_owner_or_id
                                end
            token = last_authorized_token_for(application.try(:id), resource_owner_id)
            if token && scopes_match?(token.scopes, scopes, application.try(:scopes))
              token
            end
          end

          def scopes_match?(token_scopes, param_scopes, app_scopes)
            (!token_scopes.present? && !param_scopes.present?) ||
                Doorkeeper::OAuth::Helpers::ScopeChecker.match?(
                    token_scopes.to_s,
                    param_scopes,
                    app_scopes
                )
          end

          def find_or_create_for(application, resource_owner_id, scopes, expires_in, use_refresh_token)
            if Doorkeeper.configuration.reuse_access_token
              access_token = matching_token_for(application, resource_owner_id, scopes)
              if access_token && !access_token.expired?
                return access_token
              end
            end

            new(
                application_id: application.try(:id),
                resource_owner_id: resource_owner_id,
                scopes: scopes.to_s,
                expires_in: expires_in,
                use_refresh_token: use_refresh_token
            ).save(raise_on_failure: true)
          end

          def last_authorized_token_for(application_id, resource_owner_id)
            where(application_id: application_id,
                  resource_owner_id: resource_owner_id,
                  revoked_at: nil).
                send(order_method, created_at_desc).
                limit(1).
                to_a.
                first
          end
        end

        def token_type
          'bearer'
        end

        def use_refresh_token?
          !!@use_refresh_token
        end

        def as_json(_options = {})
          {
            resource_owner_id: resource_owner_id,
            scopes: scopes,
            expires_in_seconds: expires_in_seconds,
            application: { uid: application.try(:uid) },
            created_at: created_at.to_i,
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
          write_attribute :refresh_token, UniqueToken.generate
        end

        def generate_token
          generator = Doorkeeper.configuration.access_token_generator.constantize
          self.token = generator.generate(resource_owner_id: resource_owner_id,
                                          scopes: scopes, application: application,
                                          expires_in: expires_in)
        rescue NoMethodError
          raise Errors::UnableToGenerateToken, "#{generator} does not respond to `.generate`."
        rescue NameError
          raise Errors::TokenGeneratorNotFound, "#{generator} not found"
        end
      end
    end
  end
end