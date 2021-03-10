defmodule SalesWeb.OrderController do
  use SalesWeb, :controller

  alias Sales.SaleContext
  alias Sales.SaleContext.Order

  action_fallback SalesWeb.FallbackController

  def index(conn, _params) do
    orders = SaleContext.list_orders()
    render(conn, "index.json", orders: orders)
  end

  def create(conn, params) do
    with {:ok, %Order{} = order} <- SaleContext.create_order(params) do
      conn
      |> put_status(:created)
      |> render("show.json", order: order)
    end
  end
end
