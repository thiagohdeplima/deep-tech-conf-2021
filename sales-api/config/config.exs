# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sales,
  ecto_repos: [Sales.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :sales, SalesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fbng0d2Qo3+uOosFk5XnWxrKyN7NCDj7OUGDjj7XZYNL1/vwnatoEp2JCcYp6T4M",
  render_errors: [view: SalesWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Sales.PubSub,
  live_view: [signing_salt: "9TwW3JPn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
