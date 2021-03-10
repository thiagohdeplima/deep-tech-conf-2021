# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :openid_client,
  namespace: OpenIDClient

config :openid_client,
  openid_connect_providers: [
    poc: [
      discovery_document_uri: "http://localhost:8080/auth/realms/master/.well-known/openid-configuration",
      client_id: "poc",
      client_secret: "ddd8fd5e-b0b7-475f-adc4-968f5f20e814",
      redirect_uri: "http://localhost:5000/session",
      response_type: "code",
      scope: "openid roles"
    ]
  ]


# Configures the endpoint
config :openid_client, OpenIDClientWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6SZ258zeqD+XopifXV+OAmuhRKYHsZzIJtMEKr8wAIHFt+rvgvWGVR/h2nvBKbFH",
  render_errors: [view: OpenIDClientWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: OpenIDClient.PubSub,
  live_view: [signing_salt: "HylMuYNb"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
