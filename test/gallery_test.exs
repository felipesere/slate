defmodule GalleryTests do
  use WebCase
  alias Slate.Repo

  setup do
    Repo.clear()
    :ok
  end

  test "GET /" do
    Repo.create(%Image{id: 1,
                  image: "london.jpg",
                  title: "London",
                  date: ~D[2015-03-01],
                  subtitle: "March 1, 2015"})
    conn = get("/")

    assert conn.status == 200
    assert body(conn) |> Floki.find("title") |> children() == ["Gallery"]
    assert body(conn) |> Floki.find(".asset-title") |> children() == ["London"]
  end

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
