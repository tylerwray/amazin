defmodule Amazin.Store.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t(),
          amount: integer(),
          stock: integer(),
          thumbnail: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "products" do
    field :name, :string
    field :description, :string
    field :amount, :integer
    field :stock, :integer
    field :thumbnail, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:amount, :description, :name, :stock, :thumbnail])
    |> validate_required([:amount, :description, :name, :stock, :thumbnail])
  end
end
