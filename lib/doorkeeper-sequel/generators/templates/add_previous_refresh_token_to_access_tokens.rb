Sequel.migration do
  change do
    alter_table(:oauth_access_tokens) do
      add_column :previous_refresh_token, String, default: '', null: false
    end
  end
end
