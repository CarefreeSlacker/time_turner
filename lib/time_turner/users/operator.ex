defmodule TimeTurner.Users.Operator do
  @moduledoc """
  Contains API for manipulating with operator
  """

  alias TimeTurner.Orders.Order
  alias TimeTurner.Otp.OperatorWorker
  alias TimeTurner.Users.Customer

  @spec add_order(Order.t()) :: {:ok, list(Order.t())}
  def add_order(%Order{} = order) do
    OperatorWorker.add_order(order)
  end

  @spec finish_order(integer) ::
          {:ok, Order.t()}
          | {:error, :order_does_not_exist}
          | {:error, :customer_does_not_exist}
  def finish_order(order_id) do
    case OperatorWorker.finish_order(order_id) do
      {:ok, new_order} ->
        Customer.finish_order(new_order)

      {:error, :order_does_not_exist} ->
        {:error, :order_does_not_exist}
    end
  end

  @spec remove_order(integer) ::
          {:ok, Order.t()}
          | {:error, :order_does_not_exist}
          | {:error, :order_does_not_finished}
          | {:error, :customer_does_not_exist}
          | {:error, :order_does_not_exist}
  def remove_order(order_id) do
    case OperatorWorker.remove_order(order_id) do
      {:ok, %Order{customer_id: customer_id}} ->
        Customer.remove_order(customer_id)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defdelegate get_orders, to: OperatorWorker
  defdelegate get_order(order_id), to: OperatorWorker
end
