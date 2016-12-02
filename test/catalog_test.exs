defmodule CatalogTests do
  use ExUnit.Case, async: true
  alias Slate.Catalog

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Catalog)
  end

  test "create and find an image" do
    image = Catalog.insert!(image("Some day"))

    {:ok, found} = Catalog.image(image.id)
    assert found.title == "Some day"
  end

  test "not finding an image" do
    assert :none == Catalog.image(-1)
  end

  test "stores exif data" do
    created = Catalog.insert!(image("has exif") |> Exif.add(%Exif{aperture: 11, camera: "Canon EOS 70D", focal_length: 10, iso: 100, shutter_speed: "30s" }))
    {:ok, image} = Catalog.image(created.id)
    %Exif{aperture: aperture, iso: iso} = image.exif

    assert aperture == 11
    assert iso == 100
  end

  test "create and find a gallery" do
    first = Catalog.insert!(image("First"))
    second = Catalog.insert!(image("Second"))

    created_gallery = Catalog.insert!(gallery("someday", images: [first, second]))

    {:ok, found} = Catalog.gallery(created_gallery.id)
    assert length(found.images) == 2
  end

  test "not finding a gallery" do
    assert :none == Catalog.gallery(-1)
  end

  test "all images and galleries" do
    first = Catalog.insert!(image("First"))
    second = Catalog.insert!(image("Second"))
    Catalog.insert!(image("Lone guy"))

    Catalog.insert!(gallery("someday", images: [first, second]))

    found = Catalog.all() |> Enum.map(&(&1.title))
    assert found == ["someday", "Lone guy"]
  end

  test "generic find for either images or galleries" do
    first = Catalog.insert!(image("First"))
    created_gallery = Catalog.insert!(gallery("someday", images: [first]))

    {:ok, image} = Catalog.find(first.id)
    assert image.title == "First"

    {:ok, gallery} = Catalog.find(created_gallery.id)
    assert gallery.title == "someday"
  end

  test "generic finder doesn't need to look for nothing" do
    assert :none = Catalog.find(:none)
  end

  defp image(title) do
    %Image{title: title, image: "sunset.jpeg", date: Ecto.Date.cast!(~D[2016-11-26])}
  end

  defp gallery(title, opts) do
    images = Keyword.get(opts, :images, [])
    %Gallery{title: title, date: Ecto.Date.cast!(~D[2016-11-26]), images: images}
  end
end
