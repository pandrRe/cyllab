defmodule CyllabWeb.PageController do
  use CyllabWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
