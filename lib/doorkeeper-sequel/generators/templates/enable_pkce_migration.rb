Sequel.migration do
  change do
    alter_table(:oauth_access_grants) do
      add_column :code_challenge, Integer, null: true
      add_column :code_challenge_method, String, null: true
    end
  end
end
