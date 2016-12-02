defmodule Slate.Router do
  use Plug.Router
  use Plug.Builder
  alias Slate.Catalog

  plug Plug.Static, at: "/public", from: :slate, only: ~w(main.css normalize.css)
  plug Plug.Parsers, parsers: [:multipart]
  plug Plug.Logger, log: :debug
  plug :match
  plug :dispatch

  get "/" do
    "index"
    |> Gallery.View.within_layout([entities: Catalog.all])
    |> respond(conn)
  end

  get "/gallery/:id" do
    {id, _} = Integer.parse(id)
    case Catalog.gallery(id) do
      {:ok, gallery} -> Gallery.View.within_layout("gallery", [gallery: gallery]) |> respond(conn)
      _ -> not_found(conn)
    end
  end

  get "/solo-image/:id" do
    {id, _} = Integer.parse(id)
    case Catalog.image(id) do
      {:ok, image} -> Gallery.View.within_layout("solo-image", [image: image]) |> respond(conn)
      _ -> not_found(conn)
    end
  end

  get "/admin" do
    conn = fetch_query_params(conn)
    edited_entity = Map.get(conn.params, "entity", :none)
    "index"
    |> Admin.View.within_layout([entities: Catalog.all, edited_entity: Catalog.find(edited_entity)])
    |> respond(conn)
  end

  post "/admin/gallery" do
    conn = fetch_query_params(conn)
    params = conn.params
    Catalog.create(%Image{ description: params["description"],
                        exif: params["extract_exif"],
                        title: params["title"],
                        date: params["when"]})

    redirect(conn, to: "/admin")
  end

  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    not_found(conn)
  end

  def not_found(conn) do
    send_resp(conn, 404, "oops")
  end

   def redirect(conn, [to: to]) do
    conn
    |> Plug.Conn.put_resp_header("location", to)
    |> Plug.Conn.resp(302, "")
    |> Plug.Conn.halt
  end
end
