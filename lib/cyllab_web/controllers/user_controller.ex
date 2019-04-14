defmodule CyllabWeb.UserController do
    use CyllabWeb, :controller

    alias Cyllab.People
    alias Cyllab.People.Credentials

    def index(conn, _params) do
        users = People.get_all_users()

        render(conn, "index.json", users: users)
    end

    def create(conn, params) do
        case People.insert_user_with_credentials(params) do
            {:ok, %Credentials{} = credentials} -> render(conn, "credentials.json", credentials)
            {:error, %Ecto.Changeset{} = changeset} -> conn
                |> put_status(400)
                |> render("error.json", changeset: changeset)
            {:error, msg} -> conn |> put_status(400) |> render("error.json", message: msg)
        end
    end
end