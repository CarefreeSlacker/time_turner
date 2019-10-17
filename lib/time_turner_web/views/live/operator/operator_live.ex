defmodule TimeTurnerWeb.OperatorLive do
  use TimeTurnerWeb, :live_view
  use Phoenix.LiveView

  @refresh_interval 1000
  alias Phoenix.LiveView, as: PhoenixLiveView
  alias TimeTurner.Users.Operator
  alias TimeTurnerWeb.OrderLive
  alias TimeTurnerWeb.Router.Helpers, as: Routes
  import TimeTurner.Orders, only: [time_left: 1]

  def render(assigns) do
    ~L"""
    <div>
      <h1>Operator dashboard</h1>
    </div>
    <div>
      <table class="table">
        <tr>
          <th>ID</th>
          <th>Time left</th>
          <th>Items count</th>
          <th>Total price</th>
          <th>To order</th>
        </tr>
        <%= Enum.map(@orders, fn order -> %>
          <tr>
            <td>
              <span class="badge badge-pill <%= if(order.finished, do: "badge-success", else: "badge-primary") %> ">
                Order #<%= order.id %>
              </span>
            </td>
            <td><%= order.time_left %></td>
            <td><%= length(order.items) %></td>
            <td><%= order.total_price %></td>
            <td>
              <button class="btn btn-primary" phx-click="to_order_page" phx-value-order-id="<%= order.id %>">To order</button>
            </td>
          </tr>
        <% end) %>
      </table>
    </div>
    """
  end

  def mount(_params, socket) do
    schedule_refresh()

    {:ok, get_socket_assigns(socket)}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp get_socket_assigns(socket) do
    {:ok, orders} = Operator.get_orders()

    socket
    |> assign(:orders, add_time_left_to_orders(orders))
    |> assign(:total_time_spent, calculate_total_time_spent(orders))
  end

  defp add_time_left_to_orders(orders) do
    Enum.map(orders, &Map.put(&1, :time_left, time_left(&1)))
  end

  defp calculate_total_time_spent(orders) do
    orders
    |> Enum.map(fn %{create_order_time: time} ->
      NaiveDateTime.utc_now()
      |> NaiveDateTime.diff(time)
    end)
    |> Enum.sum()
  end

  def handle_event("to_order_page", %{"order-id" => order_id}, socket) do
    {:noreply, redirect_order_page(socket, order_id)}
  end

  defp redirect_order_page(socket, order_id) do
    socket
    |> PhoenixLiveView.redirect(to: Routes.live_path(socket, OrderLive, order_id))
  end

  def handle_info(:refresh, socket) do
    schedule_refresh()
    {:noreply, get_socket_assigns(socket)}
  end
end
