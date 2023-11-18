defmodule Amazin.Store.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Amazin.Store.Product

  schema "cart_items" do
    field :quantity, :integer
    field :cart_id, :id
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
