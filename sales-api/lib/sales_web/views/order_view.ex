defmodule SalesWeb.OrderView do
  use SalesWeb, :view
  alias SalesWeb.OrderView

  def render("index.json", %{orders: orders}) do
    %{entries: render_many(orders, OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    render_one(order, OrderView, "order.json")
  end

  def render("order.json", %{order: order}) do
    %{
      id: order.id,
      status: order.status,
      product: %{
        name: order.product.name,
        price: order.product.price
      }
    }
  end
end
