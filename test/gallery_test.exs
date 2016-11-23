defmodule GalleryTests do
  use WebCase
  alias Slate.Repo

  setup do
    Repo.clear()
    :ok
  end

  test "that the index page shows all images and galleries" do
    Repo.create(%Image{id: 1,
                  image: "london.jpg",
                  title: "London",
                  date: ~D[2015-03-01],
                  subtitle: "March 1, 2015"})
    Repo.create( %Image{id: 2,
                  image: "rocks.jpg",
                  title: "Rocks",
                  date: ~D[2014-08-31],
                  subtitle: "August 31, 2014"})

    Repo.create(%Gallery{id: 3,
                  images: [1,2],
                  title: "Tenerife",
                  date: ~D[2015-11-07],
                  subtitle: "November 7, 2014"})

    conn = get("/")

    assert conn.status == 200
    assert body(conn) |> Floki.find("title") |> children() == ["Gallery"]
    assert body(conn) |> Floki.find(".asset-title") |> children() == ["London", "Rocks", "Tenerife"]
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
