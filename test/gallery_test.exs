defmodule GalleryTests do
  use WebCase
  alias Slate.Repo
  alias Slate.Catalog

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Catalog)
  end

  test "that the index page shows all images and galleries" do
    london = Catalog.insert!(Image.simple("london.jpg", "Part Of Gallery Image", ~D[2015-03-01]))
    Catalog.insert!(Image.simple("rocks.jpg", "Standalone Image", ~D[2014-08-31]))
    Catalog.insert!(Gallery.simple("The Gallery",~D[2015-01-07], images: [london]))

    conn = get("/")

    assert conn.status == 200
    assert body(conn) |> Floki.find("title") |> children() == ["Gallery"]
    assert body(conn) |> Floki.find(".asset-title") |> children() == ["The Gallery", "Standalone Image"]
  end

  @tag :skip
  test "single page" do
    Repo.create(%Image{id: 1,
                  image: "london.jpg",
                  title: "Outcropping",
                  date: ~D[2015-03-01],
                  subtitle: "March 1, 2015",
                  exif: %Exif{aperture: 11,
                    camera: "Canon EOS 70D",
                    focal_length: 10,
                    iso: 100,
                    shutter_speed: "30s"
                  }})
    conn = get("/solo-image/1")

    assert conn.status == 200
    assert body(conn) |> Floki.find(".page-title") |> children() == ["Outcropping"]
    assert body(conn) |> Floki.find(".asset-subtitle") |> children() == ["March 1, 2015"]
    assert body(conn) |> Floki.find(".exif-data") |> children() |> present
  end
end
