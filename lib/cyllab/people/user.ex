defmodule Cyllab.People.User do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Cyllab.People.Credentials

  @derive {Jason.Encoder, only: [:id, :name, :email, :confirmed, :credentials]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :confirmed, :boolean, default: false
    has_many :credentials, Credentials

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :confirmed])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
