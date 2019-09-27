# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:oauth_applications) do
      add_column :confidential, TrueClass, null: false, default: true
    end
  end
end
