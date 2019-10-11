defmodule TimeTurnerWeb.OperatorSessionsController do
  use TimeTurnerWeb, :controller

  alias TimeTurner.Interface
  alias TimeTurner.Interface.OperatorSessions

  def index(conn, _params) do
    operator_sessions = Interface.list_operator_sessions()
    render(conn, "index.html", operator_sessions: operator_sessions)
  end

  def new(conn, _params) do
    changeset = Interface.change_operator_sessions(%OperatorSessions{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"operator_sessions" => operator_sessions_params}) do
    case Interface.create_operator_sessions(operator_sessions_params) do
      {:ok, operator_sessions} ->
        conn
        |> put_flash(:info, "Operator sessions created successfully.")
        |> redirect(to: Routes.operator_sessions_path(conn, :show, operator_sessions))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    operator_sessions = Interface.get_operator_sessions!(id)
    render(conn, "show.html", operator_sessions: operator_sessions)
  end

  def edit(conn, %{"id" => id}) do
    operator_sessions = Interface.get_operator_sessions!(id)
    changeset = Interface.change_operator_sessions(operator_sessions)
    render(conn, "edit.html", operator_sessions: operator_sessions, changeset: changeset)
  end

  def update(conn, %{"id" => id, "operator_sessions" => operator_sessions_params}) do
    operator_sessions = Interface.get_operator_sessions!(id)

    case Interface.update_operator_sessions(operator_sessions, operator_sessions_params) do
      {:ok, operator_sessions} ->
        conn
        |> put_flash(:info, "Operator sessions updated successfully.")
        |> redirect(to: Routes.operator_sessions_path(conn, :show, operator_sessions))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", operator_sessions: operator_sessions, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    operator_sessions = Interface.get_operator_sessions!(id)
    {:ok, _operator_sessions} = Interface.delete_operator_sessions(operator_sessions)

    conn
    |> put_flash(:info, "Operator sessions deleted successfully.")
    |> redirect(to: Routes.operator_sessions_path(conn, :index))
  end
end
