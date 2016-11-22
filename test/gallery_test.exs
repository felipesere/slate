defmodule GalleryTests do
  use WebCase
  alias Slate.Repo

  test "GET /" do
    Repo.clear()
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
    conn = get("/solo-image/6")

    assert conn.status == 200
    assert body(conn) |> Floki.find(".page-title") |> children() == ["Outcropping"]
    assert body(conn) |> Floki.find(".asset-subtitle") |> children() == ["July 17, 2014"]
    assert body(conn) |> Floki.find(".exif-data") |> children() |> present
  end
end
