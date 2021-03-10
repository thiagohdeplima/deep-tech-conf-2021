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
    Multi.new()
    |> Multi.insert(:order, Order.changeset(%Order{}, attrs))
    |> Multi.run(:product, &get_product_if_available/2)
    |> Multi.run(:update_stock, &decrease_product_availability/2)
    |> Multi.run(:event, &publish_event/2)
    |> Repo.transaction()
    |> case do
      {:ok, %{order: order}} ->
        {:ok, Repo.preload(order, :product)}

      {:error, _, reason, _} ->
        {:error, reason}
    end
  end

  defp get_product_if_available(_, %{order: %{product_id: product_id}}) do
    case Repo.get(Product, product_id) do
      %Product{quantity: 0} ->
        {:error, :product_unavailable}

      product = %Product{} ->
        {:ok, product}
    end
  end

  defp decrease_product_availability(_, %{product: product = %{quantity: quantity}}) do
    product
    |> Product.changeset(%{quantity: quantity - 1})
    |> Repo.update()
  end

  defp publish_event(_, %{order: order}) do
    with order = %Order{} <- Repo.preload(order, :product),
         {:ok, json} <- Jason.encode(order),
         {:ok, channel} <- AMQP.Application.get_channel(:channel),
         :ok <- AMQP.Basic.publish(channel, "events", "", json)
    do
      {:ok, json}
    end
  end
end
