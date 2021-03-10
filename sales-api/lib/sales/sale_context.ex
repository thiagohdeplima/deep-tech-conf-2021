defmodule Sales.SaleContext do
  @moduledoc """
  The SaleContext context.
  """

  import Ecto.Query, warn: false
  alias Sales.Repo

  alias Sales.SaleContext.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end
end
