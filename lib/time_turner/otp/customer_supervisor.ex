defmodule TimeTurner.Otp.CustomerSupervisor do
  @moduledoc """
  Allow to spawn customers GenServer dynamically
  """

  use DynamicSupervisor
  alias TimeTurner.Otp.CustomerWorker

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def start_child(params) do
    spec = {CustomerWorker, params}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
