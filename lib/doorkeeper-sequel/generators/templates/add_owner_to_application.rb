# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:oauth_applications) do
      add_column :owner_id, Integer, null: true
      add_column :owner_type, String, null: true
      add_index %i[owner_id owner_type]
    end
  end
end
