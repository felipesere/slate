defmodule Slate.Router do
  use Plug.Router
  use Plug.Builder
  alias ExAws.S3

  plug Plug.Static, at: "/public", from: :slate, only: ~w(main.css normalize.css)
  plug :match
  plug :dispatch

  get "/" do
    render_template(conn, "index", [entities: Repo.all])
  end

  get "/gallery/:id" do
    {id, _} = Integer.parse(id)

    case Repo.gallery(id) do
      {:ok, gallery} -> View.within_layout("gallery", [gallery: gallery]) |> respond(conn)
      _ -> not_found(conn)
    end
  end

  get "/solo-image/:id" do
    {id, _} = Integer.parse(id)
    case Repo.image(id) do
      {:ok, image} -> View.within_layout("solo-image", [image: image]) |> respond(conn)
      _ -> not_found(conn)
    end
  end

  def render_template(conn, name, assigns \\ []) do
    name
    |> View.within_layout(assigns)
    |> respond(conn)
  end

  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    not_found(conn)
  end

  def not_found(conn) do
    send_resp(conn, 404, "oops")
  end
end
