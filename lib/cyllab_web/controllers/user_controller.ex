defmodule CyllabWeb.UserController do
    use CyllabWeb, :controller

    alias Cyllab.People

    def index(conn, _params) do
        users = People.get_all_users()

        render(conn, "index.json", users: users)
    end

    def create(conn, params) do
        result = People.insert_user_with_credentials params

        json(conn, result)
    end
end