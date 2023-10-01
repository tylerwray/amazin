defmodule Amazin.StoreTest do
  use Amazin.DataCase

  alias Amazin.Store

  describe "products" do
    alias Amazin.Store.Product

    import Amazin.StoreFixtures

    @invalid_attrs %{name: nil, description: nil, amount: nil, stock: nil, thumbnail: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Store.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Store.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{name: "some name", description: "some description", amount: 42, stock: 42, thumbnail: "some thumbnail"}

      assert {:ok, %Product{} = product} = Store.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.description == "some description"
      assert product.amount == 42
      assert product.stock == 42
      assert product.thumbnail == "some thumbnail"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", amount: 43, stock: 43, thumbnail: "some updated thumbnail"}

      assert {:ok, %Product{} = product} = Store.update_product(product, update_attrs)
      assert product.name == "some updated name"
      assert product.description == "some updated description"
      assert product.amount == 43
      assert product.stock == 43
      assert product.thumbnail == "some updated thumbnail"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_product(product, @invalid_attrs)
      assert product == Store.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Store.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Store.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Store.change_product(product)
    end
  end
end
