# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:oauth_access_grants) do
      add_column :resource_owner_type, String, default: nil
      add_index [:resource_owner_id, :resource_owner_type]
    end
	
    alter_table(:oauth_access_tokens) do
      add_column :resource_owner_type, String, default: nil
      add_index [:resource_owner_id, :resource_owner_type]
    end
  end
end
