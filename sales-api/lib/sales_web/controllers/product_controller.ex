defmodule SalesWeb.ProductController do
  use SalesWeb, :controller

  alias Sales.SaleContext
  alias Sales.SaleContext.Product

  action_fallback SalesWeb.FallbackController

  def index(conn, _params) do
    products = SaleContext.list_products()
    render(conn, "index.json", products: products)
  end
end
