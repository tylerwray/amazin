defmodule Amazin.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :amount, :integer
      add :description, :text
      add :name, :string
      add :stock, :integer
      add :thumbnail, :text

      timestamps()
    end
  end
end
