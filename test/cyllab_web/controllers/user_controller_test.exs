defmodule CyllabWeb.UserControllerTest do
    use CyllabWeb.ConnCase

    alias Cyllab.People
    alias Cyllab.Repo
    alias Cyllab.People.CredentialType

    @create_attrs [
        %{
            name: "Joseph Joestar",
            email: "joe@example.com",
            credentials: %{
                access_handle: "joseph_joestar",
                password: "aiusbdiusd",
                type_id: 1,
            }
        },
        %{
            name: "Anna Anneson",
            email: "anna@example.com",
            credentials: %{
                access_handle: "anna_anneson",
                password: "baidsidkbsadl",
                type_id: 1,
            }
        }
    ]

    describe "Get users from endpoint" do
        setup [:create_user]

        test "GET /", %{conn: conn} do
            response = conn |> get("/api/users") |> json_response(200)
            assert length(response) === 1
            
            response_map = Enum.at(response, 0)

            assert match?(%{
                "name" => "Joseph Joestar",
                "confirmed" => false,
                "email" => "joe@example.com",
                "credentials" => [%{
                    "access_handle" => "joseph_joestar",
                    "type" => %{ "type" => "Standard" },
                }],
            }, response_map)
        end
    end

    defp create_user(_) do
        Repo.insert!(%CredentialType{id: 1, type: "Standard"})
        {:ok, user} = People.insert_user_with_credentials(@create_attrs)
        {:ok, user: user}
    end
end
  