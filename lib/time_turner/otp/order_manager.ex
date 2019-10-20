defmodule TimeTurner.Otp.OrderManager do
  @moduledoc """
  Contains all orders list.
  Bridge between operator and customers. Allow to push events of order is ready.
  """

  use GenServer
  alias TimeTurner.Orders.Item
  alias TimeTurner.Users.Customer

  @spec find_item(integer) :: Item.t() | nil
  def find_item(item_id) do
    GenServer.call(__MODULE__, {:get_item, item_id})
  end

  @spec next_order_id :: integer
  def next_order_id do
    GenServer.call(__MODULE__, :next_order_id)
  end

  @spec next_customer_id :: integer
  def next_customer_id do
    GenServer.call(__MODULE__, :next_customer_id)
  end

  @spec get_items :: list(Item.t())
  def get_items do
    GenServer.call(__MODULE__, :get_items)
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    start_customers()
    {:ok, %{items_list: default_items_list(), next_order_id: 1, next_customer_id: 1}}
  end

  defp default_items_list do
    [
      %Item{id: 1, name: "Espresso", price: 50},
      %Item{id: 2, name: "Americano", price: 70},
      %Item{id: 3, name: "Capuccino", price: 100},
      %Item{id: 4, name: "Late", price: 120}
    ]
  end

  def handle_call({:get_item, search_item_id}, _from, %{items_list: items_list} = state) do
    {
      :reply,
      Enum.find(items_list, &(&1.id == search_item_id)),
      state
    }
  end

  def handle_call(:next_order_id, _from, %{next_order_id: next_order_id} = state) do
    {:reply, next_order_id, %{state | next_order_id: next_order_id + 1}}
  end

  def handle_call(:next_customer_id, _from, %{next_customer_id: next_customer_id} = state) do
    {:reply, next_customer_id, %{state | next_customer_id: next_customer_id + 1}}
  end

  def handle_call(:get_items, _form, %{items_list: items_list} = state) do
    {:reply, items_list, state}
  end

  defp start_customers do
    Task.async(fn ->
      [
        %{name: "First user"},
        %{name: "Second user"},
        %{name: "Third user"},
        %{name: "Fourth user"},
        %{name: "Fifth user"}
      ]
      |> Enum.each(& Customer.start_for_customer(&1))
    end)
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
