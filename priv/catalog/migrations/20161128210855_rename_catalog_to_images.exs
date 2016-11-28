defmodule Slate.Catalog.Migrations.RenameCatalogToImages do
  use Ecto.Migration

  def change do
    rename table(:catalog), to: table(:images)
  end
end
