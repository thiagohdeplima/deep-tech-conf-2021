defmodule OpenIDClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      OpenIDClientWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: OpenIDClient.PubSub},
      # Start the Endpoint (http/https)
      OpenIDClientWeb.Endpoint,
      # Start a worker by calling: OpenIDClient.Worker.start_link(arg)

      {OpenIDConnect.Worker, Application.get_env(:openid_client, :openid_connect_providers)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OpenIDClient.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OpenIDClientWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
