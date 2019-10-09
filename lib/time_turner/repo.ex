defmodule TimeTurner.Repo do
  use Ecto.Repo,
    otp_app: :time_turner,
    adapter: Ecto.Adapters.Postgres
end
