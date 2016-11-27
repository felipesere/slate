defmodule Slate.Catalog.Migrations.AddGalleries do
  use Ecto.Migration

  def change do
    create table(:galleries) do
      add :title,       :string, null: false
      add :subtitle,    :string
      add :description, :string
      add :date,        :date, null: false, autogenerate: true
      timestamps
    end
  end
end
