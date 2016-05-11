module Doorkeeper
  module Orm
    module Sequel
      module RedirectUriValidator
        extend ActiveSupport::Concern

        included do
          def validates_redirect_uri(attribute)
            value = self[attribute]

            if value.blank?
              errors.add(attribute, I18n.t(:blank, scope: redirect_uri_errors))
            else
              value.split.each do |val|
                uri = ::URI.parse(val)
                return if native_redirect_uri?(uri)
                errors.add(attribute, I18n.t(:fragment_present, scope: redirect_uri_errors)) unless uri.fragment.nil?
                errors.add(attribute, I18n.t(:relative_uri, scope: redirect_uri_errors)) if uri.scheme.nil? || uri.host.nil?
                errors.add(attribute, I18n.t(:secured_uri, scope: redirect_uri_errors)) if invalid_ssl_uri?(uri)
              end
            end
          rescue URI::InvalidURIError
            errors.add(attribute, I18n.t(:invalid_uri, scope: redirect_uri_errors))
          end

          private

          def native_redirect_uri?(uri)
            native_redirect_uri.present? && uri.to_s == native_redirect_uri.to_s
          end

          def invalid_ssl_uri?(uri)
            forces_ssl = Doorkeeper.configuration.force_ssl_in_redirect_uri
            forces_ssl && uri.try(:scheme) == 'http'
          end

          def native_redirect_uri
            Doorkeeper.configuration.native_redirect_uri
          end

          #TODO: plugin? Merge to DEFAULT_OPTIONS?
          def redirect_uri_errors
            'sequel.errors.models.doorkeeper/application.attributes.redirect_uri'
          end
        end
      end
    end
  end
end
