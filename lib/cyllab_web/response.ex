defmodule CyllabWeb.Response do
    def err(body, status_code \\ 500) do
        %{body: body, is_error: true, status_code: status_code}
    end

    def send(body, status_code \\ 200) do
        %{body: body, is_error: false, status_code: status_code}
    end
end