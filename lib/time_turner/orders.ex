defmodule TimeTurner.Orders do
  @moduledoc """
  Contains logic for working with orders
  """

  @seconds_count 60
  @order_time_limit 180
  alias TimeTurner.Orders.Order

  def time_left(%{create_order_time: time}) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.diff(time)
    |> (fn seconds_spent -> @order_time_limit - seconds_spent end).()
    |> seconds_to_minutes()
  end

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
end
