defmodule TimeTurnerWeb.OperatorLive do
  use TimeTurnerWeb, :live_view
  use Phoenix.LiveView

  alias TimeTurnerWeb.OrderLive
  alias TimeTurnerWeb.Router.Helpers, as: Routes
  import TimeTurner.Orders, only: [time_left: 1]

  def render(assigns) do
    ~L"""
    <div>
      <h1>Operator dashboard</h1>
    </div>
    <div>
        <%= Enum.map(@orders, fn order -> %>
          <div class="card">
            <div class="card-header">
              <span class="badge badge-pill badge-primary"><%= time_left(order) %></span>
              <%= live_link("To order", to: Routes.live_path(@socket, OrderLive, order.id)) %>
            </div>
            <div class="card-body">
              <div class="list-group">
                <%= Enum.map(order.items, fn %{name: item_name} -> %>
                  <button class="list-group-item list-group-item-action">item_name</button>
                <% end) %>
              </div>
            </div>
          </div>
        <% end) %>
    </div>
    """
  end

  def mount(params, socket) do
    final_socket =
      socket
      |> assign(:orders, orders())

    {:ok, final_socket}
  end

  defp orders do
    [
      %{
        id: 3442,
        total_price: 150,
        create_order_time: NaiveDateTime.utc_now(),
        items: [
          %{name: "Espresso", price: 100},
          %{name: "Muffin", price: 50}
        ],
        customer_id: 1
      },
      %{
        id: 3445,
        total_price: 100,
        create_order_time: NaiveDateTime.utc_now(),
        items: [
          %{name: "Cappucino", price: 100}
        ],
        customer_id: 2
      }
    ]
  end
end
