defmodule Sales.SaleContext do
  @moduledoc """
  The SaleContext context.
  """

  import Ecto.Query, warn: false
  alias Sales.Repo

  alias Ecto.Multi

  alias Sales.SaleContext.Order
  alias Sales.SaleContext.Product

  def list_products do
    Product
    |> Repo.all()
  end

  def list_orders do
    Order
    |> Repo.all()
    |> Enum.map(fn order ->
      Repo.preload(order, :product)
    end)
  end

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, order} ->
        {:ok, Repo.preload(order, :product)}

      another ->
        another
    end
  end
end
