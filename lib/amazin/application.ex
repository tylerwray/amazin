defmodule Amazin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AmazinWeb.Telemetry,
      # Start the Ecto repository
      Amazin.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Amazin.PubSub},
      # Start Finch
      {Finch, name: Amazin.Finch},
      # Start the Endpoint (http/https)
      AmazinWeb.Endpoint
      # Start a worker by calling: Amazin.Worker.start_link(arg)
      # {Amazin.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Amazin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AmazinWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
