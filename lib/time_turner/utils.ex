defmodule TimeTurner.Utils do
  @moduledoc """
  Helper functions
  """

  @spec id_to_integer(integer | binary) :: integer
  def id_to_integer(id) when is_integer(id), do: id

  def id_to_integer(id) when is_binary(id) do
    {integer_id, _} = Integer.parse(id)
    integer_id
  end
end
