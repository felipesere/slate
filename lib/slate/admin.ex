defmodule Slate.Admin do
  use Plug.Router
  use Plug.Builder
  alias Slate.Catalog

  plug Plug.Parsers, parsers: [:multipart]
  plug Plug.Logger, log: :debug
  plug :match
  plug :dispatch

  get "/" do
    conn = fetch_query_params(conn)
    edited_entity = Map.get(conn.params, "entity", :none)
    "index"
    |> Admin.View.within_layout([entities: Catalog.all, edited_entity: Catalog.find!(edited_entity)])
    |> respond(conn)
  end

  post "/gallery" do
    conn = fetch_query_params(conn)
    params = conn.params
    Catalog.create(%Image{ description: params["description"],
                        exif: params["extract_exif"],
                        title: params["title"],
                        date: params["when"]})

    redirect(conn, to: "/admin")
  end

   def redirect(conn, [to: to]) do
    conn
    |> Plug.Conn.put_resp_header("location", to)
    |> Plug.Conn.resp(302, "")
    |> Plug.Conn.halt
  end

  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    not_found(conn)
  end

  def not_found(conn) do
    send_resp(conn, 404, "oops")
  end
end
