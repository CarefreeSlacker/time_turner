use Mix.Config

# Configure your database
config :time_turner, TimeTurner.Repo,
  username: "postgres",
  password: "postgres",
  database: "time_turner_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :time_turner, TimeTurnerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
