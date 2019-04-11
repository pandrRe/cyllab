defmodule Cyllab.Repo.Migrations.CreateCredentialType do
  use Ecto.Migration

  def change do
    create table(:credential_type) do
      add :type, :string
    end

  end
end
