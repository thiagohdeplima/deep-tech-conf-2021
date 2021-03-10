defmodule Sales.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Sales.Repo,
      # Start the Telemetry supervisor
      SalesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sales.PubSub},
      # Start the Endpoint (http/https)
      SalesWeb.Endpoint
      # Start a worker by calling: Sales.Worker.start_link(arg)
      # {Sales.Worker, arg}
    ]

    amqp()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sales.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SalesWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp amqp do
    {:ok, channel} = AMQP.Application.get_channel(:channel)

    {:ok, _} = AMQP.Queue.declare(channel, "sales-api")
    {:ok, _} = AMQP.Queue.declare(channel, "payments-api")
    {:ok, _} = AMQP.Queue.declare(channel, "delivery-api")

    AMQP.Exchange.declare(channel, "events", :fanout, durable: true)

    AMQP.Queue.bind(channel, "sales-api", "events")
    AMQP.Queue.bind(channel, "payments-api", "events")
    AMQP.Queue.bind(channel, "delivery-api", "events")
  end
end
