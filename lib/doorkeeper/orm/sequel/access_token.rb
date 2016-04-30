require_relative 'models/access_token_mixin'

module Doorkeeper
  class AccessToken < Sequel::Model
    set_dataset :oauth_access_tokens

    include Doorkeeper::Orm::Sequel::AccessTokenMixin

    class << self
      def delete_all_for(application_id, resource_owner)
        where(application_id: application_id,
              resource_owner_id: resource_owner.id).delete
      end

      def active_for(resource_owner)
        where(resource_owner_id: resource_owner.id, revoked_at: nil)
      end

      def order_method
        :order
      end

      def created_at_desc
        Sequel.desc(:created_at)
      end

      def refresh_token_revoked_on_use?
        columns.include?(:previous_refresh_token)
      end
    end
  end
end
