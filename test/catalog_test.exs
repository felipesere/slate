defmodule CatalogTests do
  use ExUnit.Case, async: true
  alias Slate.Catalog

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Catalog)
  end

  test "create and find an image" do
    image = Catalog.insert!(image("Some day"))

    found = Catalog.image(image.id)
    assert found.title == "Some day"
  end

  test "not finding an image" do
    assert :none == Catalog.image(-1)
  end

  test "create and find a gallery" do
    first = Catalog.insert!(image("First"))
    second = Catalog.insert!(image("Second"))

    created_gallery = Catalog.insert!(gallery("someday", images: [first, second]))

    found = Catalog.gallery(created_gallery.id)
    assert length(found.images) == 2
  end

  test "not finding a gallery" do
    assert :none == Catalog.gallery(-1)
  end

  defp image(title) do
    %Image{title: title, image: "sunset.jpeg", date: Ecto.Date.cast!(~D[2016-11-26])}
  end

  defp gallery(title, opts) do
    images = Keyword.get(opts, :images, [])
    %Gallery{title: title, date: Ecto.Date.cast!(~D[2016-11-26]), images: images}
  end
end
