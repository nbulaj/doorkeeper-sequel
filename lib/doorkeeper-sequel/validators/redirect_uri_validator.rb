module DoorkeeperSequel
  module RedirectUriValidator
    extend ActiveSupport::Concern

    included do
      def validates_redirect_uri(attribute)
        value = self[attribute]

        if value.blank?
          add_error(attribute, :blank)
        else
          value.split.each do |val|
            uri = ::URI.parse(val)
            next if native_redirect_uri?(uri)
            validate_uri(uri, attribute)
          end
        end
      rescue URI::InvalidURIError
        add_error(attribute, :invalid_uri)
      end

      private

      def native_redirect_uri?(uri)
        native_redirect_uri.present? && uri.to_s == native_redirect_uri.to_s
      end

      def forbidden_uri?(uri)
        Doorkeeper.configuration.respond_to?(:forbid_redirect_uri) &&
          Doorkeeper.configuration.forbid_redirect_uri.call(uri)
      end

      def validate_uri(uri, attribute)
        {
          fragment_present: uri.fragment.present?,
          relative_uri: uri.scheme.nil? || uri.host.nil?,
          secured_uri: invalid_ssl_uri?(uri),
          forbidden_uri: forbidden_uri?(uri)
        }.each do |error, condition|
          add_error(attribute, error) if condition
        end
      end

      def invalid_ssl_uri?(uri)
        forces_ssl = Doorkeeper.configuration.force_ssl_in_redirect_uri
        non_https = uri.try(:scheme) == 'http'

        if forces_ssl.respond_to?(:call)
          forces_ssl.call(uri) && non_https
        else
          forces_ssl && non_https
        end
      end

      def native_redirect_uri
        Doorkeeper.configuration.native_redirect_uri
      end

      def add_error(attribute, error)
        scope = 'sequel.errors.models.doorkeeper/application.attributes.redirect_uri'
        errors.add(attribute, I18n.t(error, scope: scope))
      end
    end
  end
end
