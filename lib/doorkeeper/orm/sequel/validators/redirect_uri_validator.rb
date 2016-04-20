module Doorkeeper
  module Orm
    module Sequel
      module RedirectUriValidator
        extend ActiveSupport::Concern

        included do
          def validates_redirect_uri(attribute)
            value = self[attribute]

            if value.blank?
              errors.add(attribute, :blank)
            else
              value.split.each do |val|
                uri = ::URI.parse(val)
                return if native_redirect_uri?(uri)
                errors.add(attribute, :fragment_present) unless uri.fragment.nil?
                errors.add(attribute, :relative_uri) if uri.scheme.nil? || uri.host.nil?
                errors.add(attribute, :secured_uri) if invalid_ssl_uri?(uri)
              end
            end
          rescue URI::InvalidURIError
            errors.add(attribute, :invalid_uri)
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
        end
      end
    end
  end
end
