defmodule AdminTests do
  use WebCase

  setup do
    Slate.Repo.clear()
    :ok
  end


  test "GET /admin" do
    conn = get("/admin")

    assert conn.status == 200
    assert body(conn) |> Floki.find("title") |> children() == ["Admin"]
  end

  test "create a single-image entry" do
    conn = conn(:post, "/admin/gallery", %{ "description" => "The description",
                  "extract_exif" => "on",
                  "images" => [],
                  "title" => "The title",
                  "when" => "2015-04-22"})

    Slate.Router.call(conn, [])

    added_image = Slate.Repo.all |> Enum.find(&(&1.title == "The title"))
    assert added_image.id == 1
  end
end
