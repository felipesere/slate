defmodule Slate.Catalog.Migrations.IntroduceExifAsBlob do
  use Ecto.Migration

  def change do
    alter table(:images) do
      remove(:exif)
      add :exif, :map
    end
  end
end
