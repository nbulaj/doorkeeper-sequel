require_relative 'models/application_mixin'

module Doorkeeper
  class Application < Sequel::Model
    set_dataset :oauth_applications

    include Doorkeeper::Orm::Sequel::ApplicationMixin

    one_to_many :authorized_tokens, class: 'Doorkeeper::AccessToken', conditions: { revoked_at: nil }
    many_to_many :authorized_applications, join_table: :oauth_access_tokens,
                  class: self, left_key: :id, right_key: :application_id

    def self.authorized_for(resource_owner)
      ids = Doorkeeper::AccessToken
                .where(resource_owner_id: resource_owner.id, revoked_at: nil)
                .select_map(:application_id)

      where(id: ids).all
    end
  end
end
