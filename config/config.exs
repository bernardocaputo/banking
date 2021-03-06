# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :banking,
  ecto_repos: [Banking.Repo]

# Configures the endpoint
config :banking, BankingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gY/E+TBTpC88qnkOrmkmIIQE6fBtcbsXhs4rJY/QPVJhtmhbpb74SD7B+hbt0NL1",
  render_errors: [view: BankingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Banking.PubSub,
  live_view: [signing_salt: "8O3fglPK"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :banking, Banking.Accounts.Guardian,
  issuer: "banking",
  secret_key: "099wK5y3lGSbrmNDny52/hlRVCcQQbdgFLP0vilufrowpw21FuTHIcpunTCbj18l"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
