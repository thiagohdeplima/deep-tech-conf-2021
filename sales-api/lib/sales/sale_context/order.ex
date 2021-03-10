defmodule Sales.SaleContext.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :status, :string

    belongs_to :product, Sales.SaleContext.Product

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:product_id])
    |> assoc_constraint(:product)
    |> validate_required([:product_id])
    |> put_change(:status, "PENDING")
  end
end
