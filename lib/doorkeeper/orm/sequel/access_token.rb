# frozen_string_literal: true

module Doorkeeper
  class AccessToken < Sequel::Model(:oauth_access_tokens)
    include DoorkeeperSequel::AccessTokenMixin

    class << self
      def active_for(resource_owner)
        where(resource_owner_id: resource_owner.id, revoked_at: nil)
      end

      def order_method
        :order
      end

      def created_at_desc
        ::Sequel.desc(:created_at)
      end

      def refresh_token_revoked_on_use?
        columns.include?(:previous_refresh_token)
      end
    end
  end
end
