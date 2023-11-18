defmodule Amazin.Repo.Migrations.CreateCartItems do
  use Ecto.Migration

  def change do
    create table(:cart_items) do
      add :quantity, :integer
      add :cart_id, references(:carts, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end

    create index(:cart_items, [:cart_id])
    create index(:cart_items, [:product_id])
    create unique_index(:cart_items, [:cart_id, :product_id])
  end
end
