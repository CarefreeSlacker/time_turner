defmodule TimeTurner.Interface.OperatorSessions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "operator_sessions" do
    timestamps()
  end

  @doc false
  def changeset(operator_sessions, attrs) do
    operator_sessions
    |> cast(attrs, [])
    |> validate_required([])
  end
end
