defmodule Slate.Catalog.Migrations.AddImageCatalog do
  use Ecto.Migration

  def change do
    create table(:catalog) do
      add :image,       :string, null: false
      add :title,       :string, null: false
      add :subtitle,    :string
      add :description, :string
      add :exif,        :boolean, default: false
      add :date,        :date, null: false, autogenerate: true
      timestamps
    end
  end
end
