defmodule TimeTurner.Orders.Context do
  @moduledoc """
  Contains logic for working with orders
  """

  @seconds_count 60

  @doc """
  Convert seconds amount to MM:SS view
  """
  @spec seconds_to_minutes(integer) :: binary
  def seconds_to_minutes(seconds) when is_integer(seconds) do
    "#{double_digitize(div(seconds, @seconds_count))}:#{double_digitize(rem(seconds, @seconds_count))}"
  end

  @spec double_digitize(integer) :: binary
  def double_digitize(value) when value < 10, do: "0#{value}"
  def double_digitize(value), do: "#{value}"
end
