defmodule CyllabWeb.UserControllerTest do
    use CyllabWeb.ConnCase

    import Cyllab.People.Factory

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
        },
    ]

    @correct_credentials %{
        name: "Michael Jackson",
        email: "mike@example.com",
        credentials: %{
            access_handle: "mike_jackson",
            password: "password1223",
            password_confirmation: "password1223",
            type_id: 1,
        }
    }

    @incorrect_credentials1 %{
        name: "Johnny Smith",
        email: "johnny@example.com",
        credentials: %{
            access_handle: "johnny_smith",
            password: "thisisawaaaaaaaaaaytolongpassword",
            password_confirmation: "thisisawaaaaaaaaaaytolongpassword",
            type_id: 1,
        }
    }

    @incorrect_credentials2 %{
        name: "Al de Baran",
        email: "aldebaran@example.com",
        credentials: %{
            access_handle: "alde",
            password: "baran",
            password_confirmation: "baran",
            type_id: 1,
        }
    }

    @incorrect_credentials3 %{
        name: "Fulaninho",
        email: "fulaninho@example.com",
        credentials: %{
            access_handle: "fulaninho",
            password: "fulaninho",
            type_id: 1,
        }
    }

    @incorrect_credentials4 %{
        name: "Fulaninho",
        email: "fulaninho@example.com",
        credentials: %{
            access_handle: "fulaninho",
            password: "fulaninho",
            password_confirmation: "wroooong",
            type_id: 1,
        }
    }

    @incorrect_credentials5 %{
        email: "fulaninho@example.com",
        credentials: %{
            access_handle: "fulaninho",
            password: "fulaninho",
            password_confirmation: "fulaninho",
            type_id: 1,
        }
    }

    @incorrect_credentials6 %{
        name: "fulaninho",
        email: "fulaninhoatexample.com",
        credentials: %{
            access_handle: "fulaninho",
            password: "fulaninho",
            password_confirmation: "fulaninho",
            type_id: 1,
        }
    }

    @incorrect_credentials7 %{
        name: "fulaninho",
        email: "fulaninhoatexample.com",
        credentials: %{
            access_handle: "fulaninho",
            password: "fulaninho",
            password_confirmation: "fulaninho",
            type_id: 99,
        }
    }

    @incorrect_credentials8 %{
        name: "fulaninho",
        email: "fulaninhoatexample.com",
        credentials: %{}
    }


    describe "Endpoint index." do
        setup [:standard_credential_type, :create_users]

        test "index/2", %{conn: conn} do
            response = conn |> get("/api/users") |> json_response(200)
            assert length(response["body"]) === 2
            
            response_map = Enum.at(response["body"], 0)

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

    describe "User sign up endpoint." do
        setup [:standard_credential_type]

        test "create/2 with correct credentials.", %{conn: conn} do
            response = conn |> post("/api/users", @correct_credentials) |> json_response(200)

            assert match?(%{
                "access_handle" => "mike_jackson",
                "type" => %{"type" => "Standard"},
            }, response["body"])
        end

        test "create/2 with valid username but long password", %{conn: conn} do
            response = conn |> post("/api/users", @incorrect_credentials1) |> json_response(400)

            assert response === %{
                "body" => %{"password" => ["should be at most 20 character(s)"]},
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with short username and short password", %{conn: conn} do
            response = conn |> post("/api/users", @incorrect_credentials2) |> json_response(400)

            assert response === %{
                "body" => %{
                    "password" => ["should be at least 8 character(s)"],
                    "access_handle" => ["should be at least 5 character(s)"],
                },
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with missing password confirmation", %{conn: conn} do
            response = conn |> post("/api/users", @incorrect_credentials3) |> json_response(400)

            assert response === %{
                "body" => %{
                    "password_confirmation" => ["can't be blank"],
                },
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with wrong password confirmation", %{conn: conn} do
            response = conn |> post("/api/users", @incorrect_credentials4) |> json_response(400)

            assert response === %{
                "body" => %{
                    "password_confirmation" => ["does not match confirmation"],
                },
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with missing user fields", %{conn: conn} do
            response = conn |> post("/api/users", @incorrect_credentials5) |> json_response(400)

            assert response === %{
                "body" => %{
                    "user" => %{"name" => ["can't be blank"]},
                },
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with invalid email", %{conn: conn} do
            response = conn |> post("/api/users", @incorrect_credentials6) |> json_response(400)

            assert response === %{
                "body" => %{
                    "user" => %{"email" => ["has invalid format"]},
                },
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with non-existing credential type", %{conn: conn} do
            response = conn |> post("/api/users", @incorrect_credentials7) |> json_response(400)

            assert response === %{
                "body" => "Credential type does not exist.",
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with missing credential fields", %{conn: conn} do
            response = conn |> post("/api/users", @incorrect_credentials8) |> json_response(400)

            assert response === %{
                "body" => "Credential type does not exist.",
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with empty request body", %{conn: conn} do
            response = conn |> post("/api/users", %{}) |> json_response(400)

            assert response === %{
                "body" => "Credential type does not exist.",
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with empty request body except for credential type id", %{conn: conn} do
            response = conn |> post("/api/users", %{credentials: %{type_id: 1}}) |> json_response(400)

            assert response === %{
                "body" => %{
                    "access_handle" => ["can't be blank"],
                    "password" => ["can't be blank"],
                    "password_confirmation" => ["can't be blank"],
                    "user" => %{"name" => ["can't be blank"], "email" => ["can't be blank"]},
                },
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with existing email on form", %{conn: conn} do
            existing_user = insert(:user)
            form_data = build(:signup_form, email: existing_user.email)

            response = conn |> post("/api/users", form_data) |> json_response(400)

            assert response === %{
                "body" => %{
                    "user" => %{"email" => ["has already been taken"]},
                },
                "is_error" => true,
                "status_code" => 400,
            }
        end

        test "create/2 with existing access handle on form", %{conn: conn} do
            existing_user = insert(:user)
            form_data = put_in(
                build(:signup_form).credentials.access_handle,
                Enum.at(existing_user.credentials, 0).access_handle
            )

            response = conn |> post("/api/users", form_data) |> json_response(400)

            assert response === %{
                "body" => %{
                    "access_handle" => ["has already been taken"],
                },
                "is_error" => true,
                "status_code" => 400,
            }
        end
    end

    defp standard_credential_type(_) do
        Repo.insert!(%CredentialType{id: 1, type: "Standard"})
        :ok
    end

    defp create_users(_) do
        Enum.each(@create_attrs, fn attrs -> People.insert_user_seed(attrs) end) 
    end
end
  