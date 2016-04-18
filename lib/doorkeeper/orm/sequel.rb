module Doorkeeper
  module Orm
    module Sequel
      def self.initialize_models!
        require 'doorkeeper/orm/sequel/access_grant'
        require 'doorkeeper/orm/sequel/access_token'
        require 'doorkeeper/orm/sequel/application'
      end

      def self.initialize_application_owner!
        # TODO: migrate ownership
        require 'doorkeeper/models/concerns/ownership'

        Doorkeeper::Application.send :include, Doorkeeper::Models::Ownership
      end

      def self.check_requirements!(_config); end
    end
  end
end
