defmodule SalesWeb.ProductView do
  use SalesWeb, :view
  alias SalesWeb.ProductView

  def render("index.json", %{products: products}) do
    %{
      entries: render_many(products, ProductView, "product.json")
    }
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: product.quantity
    }
  end
end
