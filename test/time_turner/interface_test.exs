defmodule TimeTurner.InterfaceTest do
  use TimeTurner.DataCase

  alias TimeTurner.Interface

  describe "operator_sessions" do
    alias TimeTurner.Interface.OperatorSessions

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def operator_sessions_fixture(attrs \\ %{}) do
      {:ok, operator_sessions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Interface.create_operator_sessions()

      operator_sessions
    end

    test "list_operator_sessions/0 returns all operator_sessions" do
      operator_sessions = operator_sessions_fixture()
      assert Interface.list_operator_sessions() == [operator_sessions]
    end

    test "get_operator_sessions!/1 returns the operator_sessions with given id" do
      operator_sessions = operator_sessions_fixture()
      assert Interface.get_operator_sessions!(operator_sessions.id) == operator_sessions
    end

    test "create_operator_sessions/1 with valid data creates a operator_sessions" do
      assert {:ok, %OperatorSessions{} = operator_sessions} =
               Interface.create_operator_sessions(@valid_attrs)
    end

    test "create_operator_sessions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Interface.create_operator_sessions(@invalid_attrs)
    end

    test "update_operator_sessions/2 with valid data updates the operator_sessions" do
      operator_sessions = operator_sessions_fixture()

      assert {:ok, %OperatorSessions{} = operator_sessions} =
               Interface.update_operator_sessions(operator_sessions, @update_attrs)
    end

    test "update_operator_sessions/2 with invalid data returns error changeset" do
      operator_sessions = operator_sessions_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Interface.update_operator_sessions(operator_sessions, @invalid_attrs)

      assert operator_sessions == Interface.get_operator_sessions!(operator_sessions.id)
    end

    test "delete_operator_sessions/1 deletes the operator_sessions" do
      operator_sessions = operator_sessions_fixture()
      assert {:ok, %OperatorSessions{}} = Interface.delete_operator_sessions(operator_sessions)

      assert_raise Ecto.NoResultsError, fn ->
        Interface.get_operator_sessions!(operator_sessions.id)
      end
    end

    test "change_operator_sessions/1 returns a operator_sessions changeset" do
      operator_sessions = operator_sessions_fixture()
      assert %Ecto.Changeset{} = Interface.change_operator_sessions(operator_sessions)
    end
  end
end
