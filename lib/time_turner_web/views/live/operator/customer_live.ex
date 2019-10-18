defmodule TimeTurnerWeb.CustomerLive do
  use TimeTurnerWeb, :live_view
  use Phoenix.LiveView

  @refresh_interval 1000

  alias TimeTurner.Users.Customer
  alias TimeTurner.Orders
  alias TimeTurner.Utils

  def render(%{order_stage: :initializing} = assigns) do
    ~L"""
    <div>
      <div class="card">
        <div class="card-header">
          <table>
            <tr class="h1">
              <td>
                Customer <%= @customer.name %> page
              </td>
              <td>
                <span>Items </span>
                <span class="badge badge-pill badge-primary"><%= Orders.items_count(%{items: @items}) %></span>
              </td>
              <td>
                <span>Total price </span>
                <span class="badge badge-pill badge-warning"><%= Orders.total_price(%{items: @items}) %></span>
              </td>
              <td>
                <button class="btn btn-primary btn-xl" phx-click="make_order">Make order</button>
              </td>
            </tr>
          </table>
        </div>
        <div class="card-body">
          <div>
            <table class="table">
              <tr><th>Name</th><th>Price</th><th>Current amount</th><th></th></tr>
              <%= Enum.map(@items_list, fn %{id: id, name: item_name, price: price} -> %>
                <tr class="h2">
                  <td><%= item_name %></td>
                  <td><%= price %></td>
                  <td><%= Orders.item_in_order_count(@items, id) %></td>
                  <td>
                    <button class="btn btn-success" phx-click="add_item" phx-value-item-id=<%= id %>>+</button>
                    <button class="btn btn-danger" phx-click="remove_item" phx-value-item-id=<%= id %>>-</button>
                  </td>
                </tr>
              <% end) %>
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def render(%{order: order, order_stage: :waiting} = assigns) do
    ~L"""
    <div>
      <div class="card">
        <div class="card-header h1">
          <table>
            <tr>
              <td>
                Order ID: <span class="badge badge-pill badge-<%= @order_color %>"><%= @order.id %></span>
              </td>
              <td>
                <span>Total price: </span>
                <span class="badge badge-pill badge-warning"><%= @order.total_price %></span>
              </td>
            </tr>
          </table>
        </div>
        <div class="card-body row">
          <div class="offset-5 col-1">
            <button class="rounded-circle btn btn-success btn-circle btn-xl">
              <h1><%= @order_time_left %></h1>
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def render(%{order: order, order_stage: :finishing} = assigns) do
    ~L"""
    <div>
      <div class="card">
        <div class="card-header h1">
          <table>
            <tr>
              <td>
                Order ID: <span class="badge badge-pill badge-<%= @order_color %>"><%= @order.id %></span>
              </td>
              <td>
                <span>Total price: </span>
                <span class="badge badge-pill badge-warning"><%= @order.total_price %></span>
              </td>
            </tr>
          </table>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="offset-sm-3 offset-lg-5 col-1">
              <button class="rounded-circle btn btn-danger btn-circle btn-xl">
                <h1>Order complete</h1>
              </button>
            </div>
          </div>
          <div class="row">
            <div class="offset-sm-1 offset-lg-4">
              <h2>Please pick up your coffee :). Have a nice day.</h2>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def render(%{customer_id: customer_id} = assigns) do
    ~L"""
    <div>Customer with ID: <%= customer_id %> does not exist</div>
    """
  end

  def handle_params(%{"customer_id" => customer_id}, _uri, socket) do
    initial_socket =
      socket
      |> assign(:customer_id, Utils.id_to_integer(customer_id))
      |> assign(:items_list, Orders.get_items())
      |> get_socket_assigns()

    {:noreply, initial_socket}
  end

  def mount(_params, socket) do
    schedule_refresh()

    {:ok, socket}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp get_socket_assigns(%{assigns: %{customer_id: customer_id}} = socket, run_stage \\ :working) do
    case {Customer.get_state(customer_id), run_stage} do
      {%{order: order, customer: customer, items: items} = state, _} ->
        socket
        |> assign(:order_stage, Orders.order_stage(state))
        |> assign(:time_left, Orders.time_left(order))
        |> assign(:order, order)
        |> assign(:items, items)
        |> assign(:customer, customer)
        |> assign(:order_time_left, Orders.time_left(order))
        |> assign(:order_color, Orders.order_color(order))

      {{:error, :customer_does_not_exist}, :initial} ->
        socket

      {{:error, :customer_does_not_exist}, :working} ->
        redirect_login_page(socket)
    end
  end

  def handle_info(:refresh, socket) do
    schedule_refresh()
    {:noreply, get_socket_assigns(socket)}
  end

  def handle_event("make_order", _value, %{assigns: %{customer_id: customer_id}} = socket) do
    Customer.make_order(customer_id)
    {:noreply, get_socket_assigns(socket)}
  end

  def handle_event(
        "add_item",
        %{"item-id" => item_id},
        %{assigns: %{customer_id: customer_id}} = socket
      ) do
    Customer.add_item(customer_id, Utils.id_to_integer(item_id))
    {:noreply, get_socket_assigns(socket)}
  end

  def handle_event(
        "remove_item",
        %{"item-id" => item_id},
        %{assigns: %{customer_id: customer_id}} = socket
      ) do
    Customer.remove_item(customer_id, Utils.id_to_integer(item_id))
    {:noreply, get_socket_assigns(socket)}
  end

  def handle_event("make_order", _value, %{assigns: %{customer_id: customer_id}} = socket) do
    Customer.make_order(customer_id)
    {:noreply, get_socket_assigns(socket)}
  end

  defp redirect_login_page(socket) do
    socket
    #    |> PhoenixLiveView.redirect(to: Routes.live_path(socket, OperatorLive))
  end
end
