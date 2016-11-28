defmodule CatalogTests do
  use ExUnit.Case, async: true
  alias Slate.Catalog

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Catalog)
  end

  test "create and find an image" do
    image = Catalog.insert!(%Image{title: "Some day", image: "sunset.jpeg", date: Ecto.Date.cast!(~D[2016-11-26])})

    found = Catalog.image(image.id)
    assert found.title == "Some day"
  end

  test "not finding an image" do
    assert :none == Catalog.image(-1)
  end

  test "create and find a gallery" do
    first = Catalog.insert!(%Image{title: "First", image: "sunset.jpeg", date: Ecto.Date.cast!(~D[2016-11-26])})
    second = Catalog.insert!(%Image{title: "Second", image: "sunset.jpeg", date: Ecto.Date.cast!(~D[2016-11-26])})

    created_gallery = Catalog.insert!(%Gallery{title: "Some day", date: Ecto.Date.cast!(~D[2016-11-26]), images: [first, second]})

    found = Catalog.gallery(created_gallery.id)
    assert length(found.images) == 2
  end

  test "not finding a gallery" do
    assert :none == Catalog.gallery(-1)
  end
end
