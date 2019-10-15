defmodule TimeTurnerWeb.OperatorLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <h1>Operator dashboard</h1>
    </div>
    <div>
      <ul>
        <%= Enum.map(@orders, fn order -> %>
          <li>
            <table>
              <tr>
                <td>
                  Total price:
                </td>
                <td>
                  <%= order.total_price %>
                </td>
              </tr>
              <tr>
                <td>
                  Items count:
                </td>
                <td>
                  <%= length(order.items) %>
                </td>
              </tr>
            </table>
            <span>Total price</span><span></span>
          </li>
        <% end) %>
      </ul>
    </div>
    """
  end

  def mount(_, socket) do
    {:ok, assign(socket, :orders, orders())}
  end

  defp orders do
    [
      %{
        total_price: 150,
        items: [
          %{name: "Espresso", price: 100},
          %{name: "Muffin", price: 50}
        ]
      },
      %{
        total_price: 100,
        items: [
          %{name: "Cappucino", price: 100}
        ]
      }
    ]
  end
end
