defmodule UxCalendar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UxCalendarWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:ux_calendar, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UxCalendar.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: UxCalendar.Finch},
      # Start a worker by calling: UxCalendar.Worker.start_link(arg)
      # {UxCalendar.Worker, arg},
      # Start to serve requests, typically the last entry
      UxCalendarWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UxCalendar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UxCalendarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
