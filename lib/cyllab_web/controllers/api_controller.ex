defmodule CyllabWeb.ApiController do
    use CyllabWeb, :controller

    def index(conn, _params) do
        info = %{version: 1, v_title: "scratch"}

        render(conn, "index.json", info: info)
    end
end