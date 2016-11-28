defmodule CatalogTests do
  use ExUnit.Case, async: true
  import Ecto.Query, only: [from: 2]
  alias Slate.Catalog


  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Catalog)
  end

  test "createn an image" do
    assert %Image{} = Catalog.insert!(%Image{title: "Some day", image: "sunset.jpeg", date: Ecto.Date.cast!(~D[2016-11-26])})
  end

  test "create a gallery" do
    first = Catalog.insert!(%Image{title: "First", image: "sunset.jpeg", date: Ecto.Date.cast!(~D[2016-11-26])})
    second = Catalog.insert!(%Image{title: "Second", image: "sunset.jpeg", date: Ecto.Date.cast!(~D[2016-11-26])})

    created_gallery = Catalog.insert!(%Gallery{title: "Some day", date: Ecto.Date.cast!(~D[2016-11-26]), images: [first, second]})

    found = Catalog.one(from g in Gallery, where: g.id == ^created_gallery.id, preload: [:images])
    assert length(found.images) == 2
  end
end
