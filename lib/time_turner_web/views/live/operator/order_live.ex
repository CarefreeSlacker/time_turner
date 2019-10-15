defmodule TimeTurnerWeb.OrderLive do
  use TimeTurnerWeb, :live_view
  use Phoenix.LiveView
  alias TimeTurnerWeb.OperatorLive
  import TimeTurner.Orders.Context, only: [seconds_to_minutes: 1]

  def render(assigns) do
    ~L"""
    <div>
      <h1></h1>
    </div>
    <div>
      <div class="card">
        <div class="card-header">
          <span class="badge badge-pill badge-primary">Order #<%= @order.id %></span>
          <%= live_link("To operator page", to: Routes.live_path(@socket, OperatorLive)) %>
        </div>
        <div class="card-body">
          <div class="list-group">
            <%= Enum.map(order.items, fn %{name: item_name} -> %>
              <button class="list-group-item list-group-item-action">item_name</button>
            <% end) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(params, socket) do
    {:ok, assign(socket, :order, order())}
  end

  defp order do
    %{
      id: 3442,
      seconds_left: 123,
      items: [
        %{name: "Espresso", price: 100},
        %{name: "Muffin", price: 50}
      ]
    }
  end
end
