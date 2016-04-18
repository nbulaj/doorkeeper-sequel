module Doorkeeper
  class AccessToken < Sequel::Model
    set_dataset :oauth_access_tokens

    # TODO: migrate mixin
    include AccessTokenMixin

    def self.delete_all_for(application_id, resource_owner)
      where(application_id: application_id,
            resource_owner_id: resource_owner.id).delete
    end
    # TODO: do we need it?
    private_class_method :delete_all_for

    def self.order_method
      :order
    end

    def self.created_at_desc
      Sequel.desc(:created_at)
    end
  end
end
