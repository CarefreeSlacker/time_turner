defmodule TimeTurnerWeb.OperatorLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <table>
        <tr>
          <td colspan=2>
            <%= cond do %>
              <% @orders > 10 -> "you are very busy" %>
              <% @orders > 5 -> "you are busy" %>
              <% @orders > 0 -> "you are easy busy" %>
              <% @true -> "you are easy busy" %>
            <% end %>
          </td>
        </tr>
        <tr>
          <td>
          </td>
          <td>
          </td>
        </tr>
      </table>
    </div>
    """
  end

  # %{id: id, current_user_id: user_id}
  def mount(_, socket) do
    {:ok, assign(socket, :temperature, 34)}
  end
end
