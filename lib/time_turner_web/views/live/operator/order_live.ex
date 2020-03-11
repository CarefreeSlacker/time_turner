defmodule TimeTurnerWeb.OrderLive do
  use TimeTurnerWeb, :live_view
  use Phoenix.LiveView

  @refresh_interval 1000

  alias TimeTurner.Users.Operator
  alias TimeTurner.Orders
  alias TimeTurnerWeb.OperatorLive
  alias Phoenix.LiveView, as: PhoenixLiveView

  def render(%{order: order} = assigns) do
    ~L"""
    <div>
      <div class="card">
        <div class="card-header">
          <table>
            <tr>
              <td>
                <span class="badge badge-pill <%= if(@order.finished, do: "badge-success", else: "badge-primary") %> ">
                  Order #<%= @order.id %>
                </span>
              </td>
              <td>
                <span>Time left: </span>
                <span class="badge badge-pill badge-primary"><%= @time_left %></span>
              </td>
              <td>
                <span>Total price: </span>
                <span class="badge badge-pill badge-primary"><%= @order.total_price %></span>
              </td>
              <td>
                <button class="btn btn-primary" phx-click="to_operator_page">To operator page</button>
              </td>
            </tr>
          </table>
        </div>
        <div class="card-body">
          <div>
            <table class="table">
              <tr><th>Name</th><th>Price</th></tr>
              <%= Enum.map(@order.items, fn %{name: item_name, price: price} -> %>
                <tr><td><%= item_name %></td><td><%= price %></td></tr>
              <% end) %>
            </table>
          </div>
          <div>
            <button class="btn btn-success" phx-click="finish_order">Finish order</button>
            <%= if(@order.finished) do %>
              <button class="btn btn-warning" phx-click="remove_order">Remove order</button>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def render(%{order_id: order_id} = assigns) do
    ~L"""
    <div>Order with ID: <%= order_id %> does not exist</div>
    """
  end

  def handle_params(%{"order_id" => order_id}, _uri, socket) do
    initial_socket =
      socket
      |> assign(:order_id, order_id)
      |> get_socket_assigns(:initial)

    {:noreply, initial_socket}
  end

  def mount(params, socket) do
    schedule_refresh()
    {:ok, socket}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp get_socket_assigns(%{assigns: %{order_id: order_id}} = socket, run_stage \\ :working) do
    case {Operator.get_order(order_id), run_stage} do
      {{:ok, order}, _} ->
        socket
        |> assign(:order, order)
        |> assign(:time_left, Orders.time_left(order))

      {{:error, :order_does_not_exist}, :initial} ->
        socket

      {{:error, :order_does_not_exist}, :working} ->
        redirect_operator_page(socket)
    end
  end

  def handle_info(:refresh, socket) do
    schedule_refresh()
    {:noreply, get_socket_assigns(socket)}
  end

  def handle_event("finish_order", _value, %{assigns: %{order_id: order_id}} = socket) do
    Operator.finish_order(order_id)
    {:noreply, get_socket_assigns(socket)}
  end

  def handle_event("remove_order", _value, %{assigns: %{order_id: order_id}} = socket) do
    Operator.remove_order(order_id)
    {:noreply, get_socket_assigns(socket)}
  end

  def handle_event("to_operator_page", _value, socket) do
    {:noreply, redirect_operator_page(socket)}
  end

  defp redirect_operator_page(socket) do
    socket
    |> PhoenixLiveView.redirect(to: Routes.live_path(socket, OperatorLive))
  end
end
