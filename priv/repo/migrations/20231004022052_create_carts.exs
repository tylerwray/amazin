defmodule Amazin.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :status, :string

      timestamps()
    end
  end
end
