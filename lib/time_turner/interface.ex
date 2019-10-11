defmodule TimeTurner.Interface do
  @moduledoc """
  The Interface context.
  """

  import Ecto.Query, warn: false
  alias TimeTurner.Repo

  alias TimeTurner.Interface.OperatorSessions

  @doc """
  Returns the list of operator_sessions.

  ## Examples

      iex> list_operator_sessions()
      [%OperatorSessions{}, ...]

  """
  def list_operator_sessions do
    Repo.all(OperatorSessions)
  end

  @doc """
  Gets a single operator_sessions.

  Raises `Ecto.NoResultsError` if the Operator sessions does not exist.

  ## Examples

      iex> get_operator_sessions!(123)
      %OperatorSessions{}

      iex> get_operator_sessions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_operator_sessions!(id), do: Repo.get!(OperatorSessions, id)

  @doc """
  Creates a operator_sessions.

  ## Examples

      iex> create_operator_sessions(%{field: value})
      {:ok, %OperatorSessions{}}

      iex> create_operator_sessions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_operator_sessions(attrs \\ %{}) do
    %OperatorSessions{}
    |> OperatorSessions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a operator_sessions.

  ## Examples

      iex> update_operator_sessions(operator_sessions, %{field: new_value})
      {:ok, %OperatorSessions{}}

      iex> update_operator_sessions(operator_sessions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_operator_sessions(%OperatorSessions{} = operator_sessions, attrs) do
    operator_sessions
    |> OperatorSessions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OperatorSessions.

  ## Examples

      iex> delete_operator_sessions(operator_sessions)
      {:ok, %OperatorSessions{}}

      iex> delete_operator_sessions(operator_sessions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_operator_sessions(%OperatorSessions{} = operator_sessions) do
    Repo.delete(operator_sessions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking operator_sessions changes.

  ## Examples

      iex> change_operator_sessions(operator_sessions)
      %Ecto.Changeset{source: %OperatorSessions{}}

  """
  def change_operator_sessions(%OperatorSessions{} = operator_sessions) do
    OperatorSessions.changeset(operator_sessions, %{})
  end
end
