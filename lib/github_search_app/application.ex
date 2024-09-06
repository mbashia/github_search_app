defmodule GithubSearchApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GithubSearchAppWeb.Telemetry,
      # Start the Ecto repository
      GithubSearchApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GithubSearchApp.PubSub},
      # Start Finch
      {Finch, name: GithubSearchApp.Finch},
      # Start the Endpoint (http/https)
      GithubSearchAppWeb.Endpoint
      # Start a worker by calling: GithubSearchApp.Worker.start_link(arg)
      # {GithubSearchApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GithubSearchApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GithubSearchAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
