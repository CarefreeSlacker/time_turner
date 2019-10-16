defmodule TimeTurner.Orders.Item do
  @moduledoc """
  Contains specific item
  """

  defstruct id: 0, name: "", price: 0, picture: 0
  @type t :: %__MODULE__{}
end
