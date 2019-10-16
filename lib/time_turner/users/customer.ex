defmodule TimeTurner.Users.Customer do
  @moduledoc """
  Contains API for manipulation with customer and additional helper functions
  """

  alias TimeTurner.Orders.{Item, Order}
  alias TimeTurner.Otp.{CustomerSupervisor, CustomerWorker, OperatorWorker, OrderManager}

  defstruct id: 0, name: ""
  @id_max_value 10000
  @type t :: %__MODULE__{}

  @spec get_customer(map) :: __MODULE__.t()
  def get_customer(params) do
    id = :rand.uniform(@id_max_value)

    %__MODULE__{id: id, name: Map.get(params, :name, default_name(id))}
  end

  defp default_name(id), do: "Default user ##{id}"

  @spec start_for_customer(map | binary) :: {:ok, pid} | {:error, term}
  def start_for_customer(%{} = params) do
    CustomerSupervisor.start_child(params)
  end

  def start_for_customer(name) when is_binary(name) do
    CustomerSupervisor.start_child(%{name: name})
  end

  @spec stop_for_customer(integer) :: {:ok, :stopped} | {:error, :does_not_exist}
  def stop_for_customer(customer_id) do
    case CustomerWorker.lookup_worker(customer_id) do
      nil ->
        {:error, :does_not_exist}

      pid ->
        DynamicSupervisor.terminate_child(CustomerSupervisor, pid)
        {:ok, :stopped}
    end
  end

  @spec add_item(integer, integer) ::
          {:ok, list(Item.t())}
          | {:error, :customer_does_not_exist}
          | {:error, :item_does_not_exist}
  def add_item(customer_id, item_id) do
    with {:customer, pid} when is_pid(pid) <- {:customer, CustomerWorker.lookup_worker(customer_id)},
         {:item, item} when is_map(item) <- {:item, OrderManager.find_item(item_id)},
         items_list <- CustomerWorker.add_item(pid, item) do
      {:ok, items_list}
    else
      {:customer, nil} -> {:error, :customer_does_not_exist}
      {:item, nil} -> {:error, :item_does_not_exist}
    end
  end

  @spec make_order(integer) :: {:ok, Order.t} | {:error, :customer_does_not_exist} | {:error, :no_items} | {:ok, :order_already_exist}
  def make_order(customer_id) do
    with {:customer, pid} when is_pid(pid) <- {:customer, CustomerWorker.lookup_worker(customer_id)},
         items when length(items) > 0 <- CustomerWorker.get_items(pid),
         order_id <- OrderManager.next_order_id(),
         order <- Order.constructor(order_id, customer_id, items),
         {:ok, _orders} <- OperatorWorker.add_order(order) do
      CustomerWorker.set_order(pid, order)
    else
      {:customer, nil} ->
        {:error, :customer_does_not_exist}
      [] ->
        {:error, :no_items}
    end
  end
end
