defmodule SalesWeb.ProductController do
  use SalesWeb, :controller

  alias Sales.SaleContext
  alias Sales.SaleContext.Product

  action_fallback SalesWeb.FallbackController

  def index(conn, _params) do
    products = SaleContext.list_products()
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- SaleContext.create_product(product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_path(conn, :show, product))
      |> render("show.json", product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = SaleContext.get_product!(id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = SaleContext.get_product!(id)

    with {:ok, %Product{} = product} <- SaleContext.update_product(product, product_params) do
      render(conn, "show.json", product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = SaleContext.get_product!(id)

    with {:ok, %Product{}} <- SaleContext.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end
end
