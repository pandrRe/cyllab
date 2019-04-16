defmodule Cyllab.People.Factory do
    use ExMachina.Ecto, repo: Cyllab.Repo

    def credentials_factory do
        %Cyllab.People.Credentials{
            access_handle: sequence("handle"),
            password: sequence("password1"),
            type_id: 1,
        }
    end

    def user_factory do
        %Cyllab.People.User{
            name: "John Smith",
            email: sequence(:email, &"randomemail#{&1}@example.com"),
            credentials: [build(:credentials)]
        }
    end

    def signup_form_factory do
        %{
            name: "Josh Johnson",
            email: sequence(:email, &"email#{&1}@example.com"),
            credentials: %{
                access_handle: "josh_johnson",
                password: "joshspassword",
                password_confirmation: "joshspassword",
                type_id: 1,
            }
        }
    end
end