defmodule Cyllab.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :confirmed, :boolean, default: true
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
