defmodule AdminTests do
  use WebCase

  @opts Slate.Router.init([])

  test "GET /" do
    conn = get("/")

    conn = Slate.Router.call(conn, @opts)
    assert conn.status == 200
  end
end
