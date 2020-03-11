defmodule TimeTurner.Application do
  @moduledoc false

  use Application
  alias TimeTurner.Otp.{CustomerSupervisor, OperatorWorker, OrderManager}

  def start(_type, _args) do
    children = [
      TimeTurner.Repo,
      TimeTurnerWeb.Endpoint,
      CustomerSupervisor,
      OrderManager,
      OperatorWorker
    ]

    opts = [strategy: :one_for_one, name: TimeTurner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TimeTurnerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
