defmodule CyllabWeb.ApiView do
    use CyllabWeb, :view

    def render("index.json", %{info: info}) do
        %{info: info}
    end
end
  