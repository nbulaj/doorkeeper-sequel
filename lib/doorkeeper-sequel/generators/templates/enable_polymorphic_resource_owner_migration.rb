# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:oauth_access_grants) do
      add_column :resource_owner_type, String, default: nil
      add_index [:member_id, :message_id]
    end
	
	alter_table(:oauth_access_grants) do
      add_column :resource_owner_type, String, default: nil
      add_index [:member_id, :message_id]
    end
  end
end
