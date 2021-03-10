defmodule Sales.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string, null: false

      add :product_id, references(:products, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:orders, [:product_id])
  end
end
