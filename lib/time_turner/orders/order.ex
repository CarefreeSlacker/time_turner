defmodule TimeTurner.Orders.Order do
  @moduledoc """
  Contains order details
  """

  defstruct id: 0,
            total_price: 0,
            items: [],
            create_order_time: nil,
            customer_id: nil,
            finished: false

  @type t :: %__MODULE__{}

  @spec constructor(integer, integer, list) :: __MODULE__.t()
  def constructor(id, customer_id, items_list) do
    %__MODULE__{
      id: id,
      items: items_list,
      create_order_time: NaiveDateTime.utc_now(),
      customer_id: customer_id,
      finished: false
    }
  end
end
