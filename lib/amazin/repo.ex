defmodule Amazin.Repo do
  use Ecto.Repo,
    otp_app: :amazin,
    adapter: Ecto.Adapters.Postgres
end
