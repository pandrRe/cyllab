defmodule Cyllab.Repo.Migrations.CreateCredentials do
  use Ecto.Migration
  def change do
    create table(:credentials) do
      add :access_handle, :string
      add :password, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :type_id, references(:credential_type, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:credentials, [:access_handle], name: :credentials_access_index)
  end
end
