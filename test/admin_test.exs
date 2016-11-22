defmodule AdminTests do
  use WebCase

  test "GET /" do
    conn = get("/")

    assert conn.status == 200
    assert body(conn) |> Floki.find(".asset-title") |> children() == ["London", "Madeira", "Spring", "Tenerife", "Waves", "Outcropping", "Beach", "Rocks"]
  end

  test "single page" do
    conn = get("/solo-image/6")

    assert conn.status == 200
    assert body(conn) |> Floki.find(".page-title") |> children() == ["Outcropping"]
    assert body(conn) |> Floki.find(".asset-subtitle") |> children() == ["July 17, 2014"]
    assert body(conn) |> Floki.find(".exif-data") |> children() |> present
  end


  def children(elements) when is_list(elements), do: Enum.flat_map(elements, &children(&1))
  def children({_, _, x}), do: x

  def present([]), do: false
  def present(_elements), do: true
end
