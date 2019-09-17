require "doorkeeper/orm/sequel/stale_records_cleaner"

module Doorkeeper
  module Orm
    module Sequel
      def self.initialize_models!
        # Hack to bypass Sequel restrictions to model datasets definition.
        # As it requires valid existing table at the moment of Model class definition,
        # all the rake tasks (db:create, db:migrate, etc) would be aborted due to error.
        old_value = ::Sequel::Model.require_valid_table
        ::Sequel::Model.require_valid_table = false
        ::Sequel::Model.strict_param_setting = false
        ::Sequel::Model.plugin :json_serializer


        begin
          require "doorkeeper/orm/sequel/access_grant"
          require "doorkeeper/orm/sequel/access_token"
          require "doorkeeper/orm/sequel/application"
        ensure
          ::Sequel::Model.require_valid_table = old_value
        end
      end

      def self.initialize_application_owner!
        require "doorkeeper-sequel/mixins/concerns/ownership"

        Doorkeeper::Application.send :include, DoorkeeperSequel::Ownership
      end
    end
  end
end
