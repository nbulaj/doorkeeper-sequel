# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:oauth_access_grants) do
      add_column :code_challenge, String, null: true
      add_column :code_challenge_method, String, null: true
    end
  end
end
