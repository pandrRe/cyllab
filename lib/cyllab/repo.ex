defmodule Cyllab.Repo do
  use Ecto.Repo,
    otp_app: :cyllab,
    adapter: Ecto.Adapters.Postgres
end
