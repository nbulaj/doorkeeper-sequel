Sequel.migration do
  change do
    # TODO: double check types, keys and indexes
    create_table :oauth_applications do
      primary_key :id

      column :name, :string, null: false
      column :uid, :string, null: false, index: { unique: true }
      column :secret, :string, null: false

      column :scopes, :string, null: false, default: ''
      column :redirect_uri, :string, text: true

      column :created_at, DateTime
      column :updated_at, DateTime
    end

    create_table :oauth_access_grants do
      column :resource_owner_id, :integer, null: false

      foreign_key :application_id, :oauth_applications, null: false, on_delete: :cascade

      column :token, :string, null: false, index: { unique: true }
      column :expires_in, :integer, null: false
      column :redirect_uri, :string, text: true, null: false
      column :created_at, DateTime, null: false
      column :revoked_at, DateTime
      column :scopes, :string
    end

    create_table :oauth_access_tokens do
      column :resource_owner_id, :integer, index: true

      foreign_key :application_id, :oauth_applications, null: false, on_delete: :cascade

      # If you use a custom token generator you may need to change this column
      # from string to text, so that it accepts tokens larger than 255
      # characters. More info on custom token generators in:
      # https://github.com/doorkeeper-gem/doorkeeper/tree/v3.0.0.rc1#custom-access-token-generator
      #
      # column :token, :string, text: true, null: false
      column :token, :string, null: false, index: { unique: true }

      column :refresh_token, :string, index: { unique: true }
      column :expires_in, :integer
      column :revoked_at, DateTime
      column :created_at, DateTime, null: false
      column :scopes, :string
    end
  end
end
