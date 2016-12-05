defmodule AdminTests do
  use WebCase
  alias Slate.Catalog
  alias Slate.Admin.Credentials

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Catalog)
  end

  test "reach the login page" do
    conn = get("/admin/login")

    assert conn.status == 200
  end

  test "invalid username and password" do
    conn = conn(:post, "/admin/login", %{"username" => "Bob", "password" => "Sinclair"})

    conn = Slate.Router.call(conn, [])

    assert conn.status == 302
    assert location(conn) =~ "/admin/login"
  end

  test "valid username and password" do
    Credentials.set(username: "Felipe", password: "Sere")
    conn = conn(:post, "/admin/login", %{"username" => "Felipe", "password" => "Sere"})

    conn = Slate.Router.call(conn, [])

    assert conn.status == 302
    assert location(conn) =~ "/admin"
    assert from_session(conn, :authenticated)
  end

  def from_session(conn, key) do
    conn
    |> Plug.Conn.fetch_session
    |> Plug.Conn.get_session(key)
  end

  @tag :skip
  test "GET /admin" do
    conn = get("/admin")

    assert conn.status == 200
    assert body(conn) |> Floki.find("title") |> children() == ["Admin"]
  end

  @tag :skip
  test "create a single-image entry" do
    conn = conn(:post, "/admin/gallery", %{ "description" => "The description",
                  "extract_exif" => "on",
                  "images" => [],
                  "title" => "The title",
                  "when" => "2015-04-22"})

    Slate.Router.call(conn, [])

    added_image = Slate.Catalog.all |> Enum.find(&(&1.title == "The title"))
    assert added_image.id == 1
  end
end
