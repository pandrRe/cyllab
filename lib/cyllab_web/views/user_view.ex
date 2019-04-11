defmodule CyllabWeb.UserView do
    use CyllabWeb, :view

    def render("index.json", %{users: users}) do
        users
    end
end
  