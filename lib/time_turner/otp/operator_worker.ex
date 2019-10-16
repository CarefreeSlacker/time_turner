defmodule TimeTurner.Otp.OperatorWorker do
  @moduledoc """
  Stores customer data during application working. Instead of database.
  """

  use GenServer
  alias TimeTurner.Orders.Order

  @spec add_order(Order.t()) :: {:ok, list(Order.t())}
  def add_order(order) do
    GenServer.call(__MODULE__, {:add_order, order})
  end

  @spec finish_order(Order.t()) :: {:ok, Order.t()} | {:error, :order_does_not_exist}
  def finish_order(order) do
    GenServer.call(__MODULE__, {:finish_order, order})
  end

  @spec remove_order(Order.t()) ::
          {:ok, list(Order.t())}
          | {:ok, :order_does_not_finished}
          | {:ok, :order_does_not_exist}
  def remove_order(order) do
    GenServer.call(__MODULE__, {:remove_order, order})
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

  def handle_call({:finish_order, order}, _from, %{orders: orders} = state) do
    order
    |> find_order_index(orders)
    |> case do
      nil ->
        {:reply, {:error, :order_does_not_exist}, state}
      order_index ->
        old_order = Enum.at(orders)
        new_order = %{old_order | finished: true}
        new_orders = List.update_at(orders, order_index, fn _v -> new_order end)
        {:reply, {:ok, new_order}, %{state | orders: new_orders}}
    end
  end

  def handle_call({:remove_order, order}, _from, %{orders: orders} = state) do
    order
    |> find_order_index(orders)
    |> case do
         nil ->
           {:reply, {:error, :order_does_not_exist}, state}
         order_index ->
           found_order = Enum.at(orders)
           if(found_order.finished) do
             new_orders = List.delete(orders, order_index)
             {:reply, {:ok, new_orders}, %{state | orders: new_orders}}
           else
             {:reply, {:error, :order_does_not_finished}, state}
           end
       end
  end

  @spec find_order_index(Order.t, list(Order)) :: Order.t | nil
  defp find_order_index(%{id: search_order_id} = order, orders_list) do
    Enum.find_index(orders_list, &(&1.id == search_order_id))
  end
end
