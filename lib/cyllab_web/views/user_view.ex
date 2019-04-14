defmodule CyllabWeb.UserView do
    use CyllabWeb, :view

    alias CyllabWeb.Response
    alias Cyllab.People.Credentials

    def render("index.json", %{users: users}) do
        Response.send users
    end

    def render("credentials.json", %Credentials{} = credentials) do
        Response.send credentials
    end

    def render("error.json", %{changeset: %Ecto.Changeset{} = changeset}) do
        Response.err Ecto.Changeset.traverse_errors(changeset, &translate_error/1), 400
    end

    def render("error.json", %{message: message}) do
        Response.err message, 400
    end
end
  