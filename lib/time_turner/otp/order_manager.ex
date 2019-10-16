defmodule TimeTurner.Otp.OrderManager do
  @moduledoc """
  Contains all orders list.
  Bridge between operator and customers. Allow to push events of order is ready.
  """

  use GenServer
  alias TimeTurner.Orders.Item

  @spec find_item(integer) :: Item.t | nil
  def find_item(item_id) do
    GenServer.call(__MODULE__, {:get_item, item_id})
  end

  @spec next_order_id :: integer
  def next_order_id do
    GenServer.call(__MODULE__, :next_order_id)
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{items_list: default_items_list(), next_order_id: 1}}
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
    {:reply, next_order_id, %{state | next_order_id: (next_order_id + 1)}}
  end
end
