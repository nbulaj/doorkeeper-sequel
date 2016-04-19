module Doorkeeper
  module Orm
    module Sequel
      module RedirectUriValidator
        extend ActiveSupport::Concern

        included do
          # https://github.com/doorkeeper-gem/doorkeeper/blob/master/app/validators/redirect_uri_validator.rb
          def validates_redirect_uri(attribute)
            if value.blank?
              record.errors.add(attribute, :blank)
            else
              value.split.each do |val|
                uri = ::URI.parse(val)
                # TODO: need to be migrated
                # return if native_redirect_uri?(uri)
                record.errors.add(attribute, :fragment_present) unless uri.fragment.nil?
                record.errors.add(attribute, :relative_uri) if uri.scheme.nil? || uri.host.nil?
                record.errors.add(attribute, :secured_uri) if invalid_ssl_uri?(uri)
              end
            end
          rescue URI::InvalidURIError
            record.errors.add(attribute, :invalid_uri)
          end

          private

          def invalid_ssl_uri?(uri)
            forces_ssl = Doorkeeper.configuration.force_ssl_in_redirect_uri
            forces_ssl && uri.try(:scheme) == 'http'
          end
        end
      end
    end
  end
end
