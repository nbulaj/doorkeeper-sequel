module DoorkeeperSequel
  module AccessGrantMixin
    extend ActiveSupport::Concern

    include SequelCompat
    include Doorkeeper::OAuth::Helpers
    include Doorkeeper::Models::Expirable
    include Doorkeeper::Models::Revocable
    include Doorkeeper::Models::Accessible
    include Doorkeeper::Models::Scopes

    included do
      plugin :validation_helpers
      plugin :timestamps

      many_to_one :application, class: 'Doorkeeper::Application'

      set_allowed_columns :resource_owner_id, :application_id,
                          :expires_in, :redirect_uri, :scopes

      def before_validation
        generate_token if new?
        super
      end

      def validate
        super
        validates_presence [:resource_owner_id, :application_id,
                            :token, :expires_in, :redirect_uri]
        validates_unique [:token]
      end
    end

    module ClassMethods
      def by_token(token)
        first(token: token.to_s)
      end
    end

    private

    def generate_token
      self.token = UniqueToken.generate
    end
  end
end
