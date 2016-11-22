defmodule Slate.Router do
  use Plug.Router
  use Plug.Builder
  alias ExAws.S3

  plug Plug.Static, at: "/public", from: :slate, only: ~w(main.css normalize.css)
  plug Plug.Parsers, parsers: [:multipart]
  plug Plug.Logger, log: :debug
  plug :match
  plug :dispatch

  get "/" do
    "index"
    |> Gallery.View.within_layout([entities: Repo.all])
    |> respond(conn)
  end

  get "/gallery/:id" do
    {id, _} = Integer.parse(id)
    case Repo.gallery(id) do
      {:ok, gallery} -> Gallery.View.within_layout("gallery", [gallery: gallery]) |> respond(conn)
      _ -> not_found(conn)
    end
  end

  get "/solo-image/:id" do
    {id, _} = Integer.parse(id)
    case Repo.image(id) do
      {:ok, image} -> Gallery.View.within_layout("solo-image", [image: image]) |> respond(conn)
      _ -> not_found(conn)
    end
  end

  get "/admin" do
    conn = fetch_query_params(conn)
    edited_entity = Map.get(conn.params, "entity", :none)
    "index"
    |> Admin.View.within_layout([entities: Repo.all, edited_entity: Repo.find(edited_entity)])
    |> respond(conn)
  end

  post "/admin/gallery" do
    respond("hi there", conn)
  end

  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    not_found(conn)
  end

  def not_found(conn) do
    send_resp(conn, 404, "oops")
  end
end
