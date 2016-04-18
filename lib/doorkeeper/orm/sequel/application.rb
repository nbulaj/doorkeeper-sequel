module Doorkeeper
  class Application < Sequel::Model
    set_dataset :oauth_applications

    include ApplicationMixin

    one_to_many :authorized_tokens, class: 'Doorkeeper::AccessToken', conditions: { revoked_at: nil }
    many_to_many :authorized_applications, join_table: :authorized_tokens

    def self.column_names_with_table
      self.columns.map { |c| "#{table_name}.#{c}" }
    end

    def self.authorized_for(resource_owner)
      ids = Doorkeeper::AccessToken.where(resource_owner_id: resource_owner.id, revoked_at: nil).select_map(:application_id)
      where(id: ids)
    end
  end
end
