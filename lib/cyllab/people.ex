defmodule Cyllab.People do
    @moduledoc """
    Context for users, including accounts, spaces, etc.
    """

    import Ecto.Query, warn: false
    alias Cyllab.Repo
    alias Cyllab.People.{User, Credentials, CredentialType}

    @doc """
    Fetch all users.
    """
    def get_all_users do
        User
        |> Repo.all()
        |> Repo.preload(credentials: [:type])
    end

    @doc """
    Fetch a single user.
    """
    def get_user(id) do
        User
        |> Repo.get(id)
        |> Repo.preload(credentials: [:type])
    end

    @doc """
    Creates a new user schema from input data without persisting it to DB.
    """
    def new_user(input) do
        User.changeset(%User{}, input)
    end

    @doc """
    Creates a new credentials schema from input data and associations.
    """
    def new_credentials(%{"credentials" => credentials}, user, credential_type) do
        %Credentials{}
        |> Credentials.changeset(credentials, credential_type, user)
    end

    @doc """
    Insert a new user with credentials.
    Returns {:ok, credentials} | {:error, changeset} | {:error, message}
    """
    def insert_user_with_credentials(input \\ %{}) do
        credential_type = Repo.get(CredentialType, input["credentials"]["type_id"] || 0)

        if credential_type do
            user = new_user(input)

            new_credentials(input, user, credential_type) |> Repo.insert()
        else
            {:error, "Credential type does not exist."}
        end
    end

    @doc """
    Insert a new user without password encryption. For test purposes only!
    """
    def insert_user_seed(input) do
        credential_type = Repo.get(CredentialType, input.credentials.type_id)

        if credential_type do
            user = new_user(input)

            %Credentials{}
            |> Credentials.test_changeset(input.credentials)
            |> Ecto.Changeset.put_assoc(:type, credential_type)
            |> Ecto.Changeset.put_assoc(:user, user)
            |> Repo.insert!()
        else
            {:error, "Credential type does not exist."}
        end
    end
end