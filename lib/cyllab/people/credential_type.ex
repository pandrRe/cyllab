defmodule Cyllab.People.CredentialType do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cyllab.People.Credentials

  @derive {Jason.Encoder, only: [:id, :type]}
  schema "credential_type" do
    field :type, :string
    has_many :credentials, Credentials, foreign_key: :type_id
  end

  @doc false
  def changeset(credential_type, attrs) do
    credential_type
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end
end
