defmodule Cyllab.People.Credentials do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cyllab.People.User
  alias Cyllab.People.CredentialType
  

  @derive {Jason.Encoder, only: [:id, :access_handle, :type]}
  schema "credentials" do
    field :access_handle, :string
    field :password, :string
    belongs_to :user, User
    belongs_to :type, CredentialType

    timestamps()
  end

  def encrypt_password(changeset) do
    plain_password = get_field(changeset, :password)
    put_change(changeset, :password, Argon2.hash_pwd_salt(plain_password))
  end

  @doc false
  def changeset(credentials, attrs) do
    credentials
    |> cast(attrs, [:access_handle, :password])
    |> validate_required([:access_handle, :password])
    |> validate_confirmation(:password)
    |> encrypt_password()
  end
end
