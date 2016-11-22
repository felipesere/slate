defmodule AdminTests do
  use WebCase

  test "GET /" do
    conn = get("/")

    assert conn.status == 200
    assert body(conn) |> Floki.find(".asset-title") |> children() == ["London", "Madeira", "Spring", "Tenerife", "Waves", "Outcropping", "Beach", "Rocks"]
  end


  def children(elements) when is_list(elements), do: Enum.flat_map(elements, &children(&1))
  def children({_, _, x}), do: x
end
