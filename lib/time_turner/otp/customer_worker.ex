defmodule TimeTurner.Otp.CustomerWorker do
  @moduledoc """
  Stores customer data during application working. Instead of database.
  """

  use GenServer
  alias TimeTurner.Users.Customer
  alias TimeTurner.Orders.{Item, Order}
  alias TimeTurner.Otp.OperatorWorker

  @spec add_item(pid, Item.t()) :: list(Item)
  def add_item(pid, item) do
    GenServer.call(pid, {:add_item, item})
  end

  @spec remove_item(pid, Item.t()) :: list(Item)
  def remove_item(pid, item) do
    GenServer.call(pid, {:remove_item, item})
  end

  @spec get_items(pid) :: list(Item)
  def get_items(pid) do
    GenServer.call(pid, :get_items)
  end

  @spec set_order(pid, Order.t()) :: {:ok, Order.t()} | {:error, :order_already_exist}
  def set_order(pid, order) do
    GenServer.call(pid, {:set_order, order})
  end

  @spec update_order(pid, Order.t()) :: {:ok, Order.t()} | {:error, :order_does_not_exist}
  def update_order(pid, order) do
    GenServer.call(pid, {:update_order, order})
  end

  @spec remove_order(pid) :: {:ok, Order.t()} | {:error, :order_does_not_exist}
  def remove_order(pid) do
    GenServer.call(pid, :remove_order)
  end

  @spec lookup_worker(integer) :: pid | nil
  def lookup_worker(customer_id) do
    GenServer.whereis(worker_alias(customer_id))
  end

  @spec customer_state(pid) :: map
  def customer_state(pid) do
    :sys.get_state(pid)
  end

  def worker_alias(customer_id) do
    :"#{__MODULE__}##{customer_id}"
  end

  def start_link(%{name: _name} = params) do
    customer = %{id: customer_id} = Customer.get_customer(params)
    GenServer.start_link(__MODULE__, customer, name: worker_alias(customer_id))
  end

  def init(customer) do
    {:ok, %{customer: customer, order: nil, items: []}}
  end

  def handle_call({:add_item, item}, _from, %{items: items} = state) do
    new_items = [item] ++ items
    {:reply, new_items, %{state | items: new_items}}
  end

  def handle_call({:remove_item, item}, _from, %{items: items} = state) do
    new_items = List.delete(items, item)
    {:reply, new_items, %{state | items: new_items}}
  end

  def handle_call(:get_items, _from, %{items: items} = state) do
    {:reply, items, state}
  end

  def handle_call({:set_order, order}, _from, %{order: nil} = state) do
    {:reply, {:ok, order}, %{state | order: order}}
  end

  def handle_call({:set_order, _order}, _from, state) do
    {:reply, {:error, :order_already_exist}, state}
  end

  def handle_call({:update_order, _order}, _from, %{order: nil} = state) do
    {:reply, {:error, :order_does_not_exist}, state}
  end

  def handle_call({:update_order, order}, _from, state) do
    {:reply, {:ok, order}, %{state | order: order}}
  end

  def handle_call(:remove_order, _from, %{order: nil} = state) do
    {:reply, {:error, :order_does_not_exist}, state}
  end

  def handle_call(:remove_order, _from, %{order: order} = state) do
    {:reply, {:ok, order}, %{state | order: nil, items: []}}
  end
end
