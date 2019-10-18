defmodule TimeTurner.Orders do
  @moduledoc """
  Contains logic for working with orders
  """

  @seconds_count 60
  @order_time_limit 10
  alias TimeTurner.Orders.Order
  alias TimeTurner.Otp.OrderManager

  def time_left(%{create_order_time: time}) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.diff(time)
    |> (fn seconds_spent -> @order_time_limit - seconds_spent end).()
    |> seconds_to_minutes()
  end

  def time_left(_), do: nil

  @doc """
  Convert seconds amount to MM:SS view
  """
  @spec seconds_to_minutes(integer) :: binary
  def seconds_to_minutes(seconds) when is_integer(seconds) and seconds >= 0 do
    "#{double_digitize(div(seconds, @seconds_count))}:#{
      double_digitize(rem(seconds, @seconds_count))
    }"
  end

  def seconds_to_minutes(_seconds), do: "00:00"

  @spec double_digitize(integer) :: binary
  def double_digitize(value) when value < 10, do: "0#{value}"
  def double_digitize(value), do: "#{value}"

  @spec order_stage(map) :: :initializing | :waiting | :finishing
  def order_stage(%{order: nil}), do: :initializing
  def order_stage(%{order: %Order{finished: false}}), do: :waiting
  def order_stage(%{order: %Order{finished: true}}), do: :finishing

  defdelegate get_items, to: OrderManager

  @spec item_in_order_count(list, integer) :: integer
  def item_in_order_count(items_list, search_item_id) do
    items_list
    |> Enum.filter(fn %{id: item_id} -> item_id == search_item_id end)
    |> length()
  end

  @spec items_count(map) :: integer
  def items_count(%{items: items}), do: length(items)
  def items_count(_), do: 0

  @spec total_price(map) :: integer
  def total_price(%{total_price: total_price}), do: total_price

  def total_price(%{items: items}) do
    items
    |> Enum.map(& &1.price)
    |> Enum.sum()
  end

  def total_price(_), do: 0

  @spec finished?(map) :: boolean
  def finished?(%{finished: finished}), do: finished
  def finished?(_), do: false

  @spec order_color(Order.t()) :: binary
  def order_color(%{finished: true}), do: "success"

  def order_color(order) do
    order
    |> time_left()
    |> case do
      "00:00" -> "danger"
      _ -> "primary"
    end
  end
end
