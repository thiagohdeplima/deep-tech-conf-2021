defmodule Sales.SaleContextTest do
  use Sales.DataCase

  alias Sales.SaleContext

  describe "products" do
    alias Sales.SaleContext.Product

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SaleContext.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert SaleContext.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert SaleContext.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = SaleContext.create_product(@valid_attrs)
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SaleContext.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = SaleContext.update_product(product, @update_attrs)
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = SaleContext.update_product(product, @invalid_attrs)
      assert product == SaleContext.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = SaleContext.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> SaleContext.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = SaleContext.change_product(product)
    end
  end
end
