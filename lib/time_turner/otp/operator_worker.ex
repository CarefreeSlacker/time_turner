defmodule TimeTurner.Otp.OperatorWorker do
  @moduledoc """
  Stores customer data during application working. Instead of database.
  """

  use GenServer
  alias TimeTurner.Orders.Order
  alias TimeTurner.Utils

  @spec add_order(Order.t()) :: {:ok, list(Order.t())}
  def add_order(order) do
    GenServer.call(__MODULE__, {:add_order, order})
  end

  @spec finish_order(integer) :: {:ok, Order.t()} | {:error, :order_does_not_exist}
  def finish_order(order_id) do
    GenServer.call(__MODULE__, {:finish_order, order_id})
  end

  @spec remove_order(integer) ::
          {:ok, list(Order.t())}
          | {:ok, :order_does_not_finished}
          | {:ok, :order_does_not_exist}
  def remove_order(order_id) do
    GenServer.call(__MODULE__, {:remove_order, order_id})
  end

  @spec get_orders :: {:ok, list(Order.t())}
  def get_orders do
    GenServer.call(__MODULE__, :get_orders)
  end

  @spec get_order(integer) :: {:ok, Order.t()} | {:error, :order_does_not_exist}
  def get_order(order_id) do
    GenServer.call(__MODULE__, {:get_order, order_id})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{orders: []}}
  end

  def handle_call({:add_order, order}, _from, %{orders: orders} = state) do
    new_orders = [order] ++ orders
    {:reply, {:ok, new_orders}, %{state | orders: new_orders}}
  end

  def handle_call({:finish_order, order_id}, _from, %{orders: orders} = state) do
    order_id
    |> find_order_index(orders)
    |> case do
      nil ->
        {:reply, {:error, :order_does_not_exist}, state}

      order_index ->
        old_order = Enum.at(orders, order_index)
        new_order = %{old_order | finished: true}
        new_orders = List.update_at(orders, order_index, fn _v -> new_order end)
        {:reply, {:ok, new_order}, %{state | orders: new_orders}}
    end
  end

  def handle_call({:remove_order, order_id}, _from, %{orders: orders} = state) do
    order_id
    |> find_order_index(orders)
    |> case do
      nil ->
        {:reply, {:error, :order_does_not_exist}, state}

      order_index ->
        found_order = Enum.at(orders, order_index)

        if(found_order.finished) do
          new_orders = List.delete(orders, found_order)
          {:reply, {:ok, found_order}, %{state | orders: new_orders}}
        else
          {:reply, {:error, :order_does_not_finished}, state}
        end
    end
  end

  def handle_call(:get_orders, _from, %{orders: orders} = state) do
    {:reply, {:ok, orders}, state}
  end

  def handle_call({:get_order, order_id}, _from, %{orders: orders} = state) do
    order_id
    |> find_order_index(orders)
    |> case do
      nil ->
        {:reply, {:error, :order_does_not_exist}, state}

      order_index ->
        {:reply, {:ok, Enum.at(orders, order_index)}, state}
    end
  end

  @spec find_order_index(integer | binary, list(Order)) :: Order.t() | nil
  defp find_order_index(search_order_id, orders_list) do
    integer_order_id = Utils.id_to_integer(search_order_id)
    Enum.find_index(orders_list, &(&1.id == integer_order_id))
  end
end
