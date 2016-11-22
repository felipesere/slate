defmodule AdminTests do
  use WebCase


  test "GET /admin" do
    conn = get("/admin")

    assert conn.status == 200
    assert body(conn) |> Floki.find("title") |> children() == ["Admin"]
  end
end
