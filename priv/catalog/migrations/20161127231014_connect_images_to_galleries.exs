defmodule Slate.Catalog.Migrations.ConnectImagesToGalleries do
  use Ecto.Migration

  def change do
    alter table(:catalog) do
      add :gallery_id, references(:galleries)
    end
  end
end
