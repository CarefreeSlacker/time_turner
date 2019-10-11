defmodule TimeTurnerWeb.OperatorSessionsControllerTest do
  use TimeTurnerWeb.ConnCase

  alias TimeTurner.Interface

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:operator_sessions) do
    {:ok, operator_sessions} = Interface.create_operator_sessions(@create_attrs)
    operator_sessions
  end

  describe "index" do
    test "lists all operator_sessions", %{conn: conn} do
      conn = get(conn, Routes.operator_sessions_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Operator sessions"
    end
  end

  describe "new operator_sessions" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.operator_sessions_path(conn, :new))
      assert html_response(conn, 200) =~ "New Operator sessions"
    end
  end

  describe "create operator_sessions" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.operator_sessions_path(conn, :create), operator_sessions: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.operator_sessions_path(conn, :show, id)

      conn = get(conn, Routes.operator_sessions_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Operator sessions"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.operator_sessions_path(conn, :create), operator_sessions: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Operator sessions"
    end
  end

  describe "edit operator_sessions" do
    setup [:create_operator_sessions]

    test "renders form for editing chosen operator_sessions", %{conn: conn, operator_sessions: operator_sessions} do
      conn = get(conn, Routes.operator_sessions_path(conn, :edit, operator_sessions))
      assert html_response(conn, 200) =~ "Edit Operator sessions"
    end
  end

  describe "update operator_sessions" do
    setup [:create_operator_sessions]

    test "redirects when data is valid", %{conn: conn, operator_sessions: operator_sessions} do
      conn = put(conn, Routes.operator_sessions_path(conn, :update, operator_sessions), operator_sessions: @update_attrs)
      assert redirected_to(conn) == Routes.operator_sessions_path(conn, :show, operator_sessions)

      conn = get(conn, Routes.operator_sessions_path(conn, :show, operator_sessions))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, operator_sessions: operator_sessions} do
      conn = put(conn, Routes.operator_sessions_path(conn, :update, operator_sessions), operator_sessions: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Operator sessions"
    end
  end

  describe "delete operator_sessions" do
    setup [:create_operator_sessions]

    test "deletes chosen operator_sessions", %{conn: conn, operator_sessions: operator_sessions} do
      conn = delete(conn, Routes.operator_sessions_path(conn, :delete, operator_sessions))
      assert redirected_to(conn) == Routes.operator_sessions_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.operator_sessions_path(conn, :show, operator_sessions))
      end
    end
  end

  defp create_operator_sessions(_) do
    operator_sessions = fixture(:operator_sessions)
    {:ok, operator_sessions: operator_sessions}
  end
end
