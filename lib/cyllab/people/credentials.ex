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

  defp encrypt_password(changeset) do
    plain_password = get_field(changeset, :password)
    put_change(changeset, :password, Argon2.hash_pwd_salt(plain_password))
  end

  @doc false
  def changeset(credentials, attrs, credential_type, user) do
    changeset = credentials
    |> cast(attrs, [:access_handle, :password])
    |> validate_required([:access_handle, :password])
    |> unique_constraint(:access_handle, name: :credentials_access_index)
    |> validate_length(:access_handle, min: 5, max: 20)
    |> validate_length(:password, min: 8, max: 20)
    |> validate_confirmation(:password, required: true)
    |> put_assoc(:type, credential_type)
    |> put_assoc(:user, user)
    
    if changeset.valid? do
      encrypt_password(changeset)
    else
      changeset
    end
  end

  def test_changeset(credentials, attrs) do
    credentials
    |> cast(attrs, [:access_handle, :password])
    |> validate_required([:access_handle, :password])
    |> validate_confirmation(:password)
  end
end
