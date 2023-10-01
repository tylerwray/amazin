defmodule Amazin.StoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Amazin.Store` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        amount: 42,
        stock: 42,
        thumbnail: "some thumbnail"
      })
      |> Amazin.Store.create_product()

    product
  end
end
