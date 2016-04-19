require_relative 'mixins/access_token_mixin'

module Doorkeeper
  class AccessToken < Sequel::Model
    set_dataset :oauth_access_tokens

    include Doorkeeper::Orm::Sequel::AccessTokenMixin

    def self.delete_all_for(application_id, resource_owner)
      where(application_id: application_id,
            resource_owner_id: resource_owner.id).delete
    end

    def self.order_method
      :order
    end

    def self.created_at_desc
      Sequel.desc(:created_at)
    end
  end
end
