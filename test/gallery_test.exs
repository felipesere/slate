defmodule GalleryTests do
  use WebCase
  alias Slate.Repo

  test "GET /" do
    conn = get("/")

    assert conn.status == 200
    assert body(conn) |> Floki.find("title") |> children() == ["Gallery"]
    assert body(conn) |> Floki.find(".asset-title") |> children() == ["London", "Madeira", "Spring", "Tenerife", "Waves", "Outcropping", "Beach", "Rocks"]
  end

  test "single page" do
    conn = get("/solo-image/6")

    assert conn.status == 200
    assert body(conn) |> Floki.find(".page-title") |> children() == ["Outcropping"]
    assert body(conn) |> Floki.find(".asset-subtitle") |> children() == ["July 17, 2014"]
    assert body(conn) |> Floki.find(".exif-data") |> children() |> present
  end
end
