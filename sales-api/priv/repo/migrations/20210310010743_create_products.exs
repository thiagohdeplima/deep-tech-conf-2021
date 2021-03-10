defmodule Sales.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name,     :string,  null: false
      add :price,    :integer, null: false
      add :quantity, :integer, null: false

      timestamps()
    end

    create unique_index(:products, :name)
  end
end
