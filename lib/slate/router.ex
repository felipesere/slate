defmodule Slate.Router do
  use Plug.Router
  use Plug.Builder
  alias ExAws.S3

  plug Plug.Static, at: "/public", from: :slate, only: ~w(main.css normalize.css)
  plug :match
  plug :dispatch

  get "/" do
    render_template(conn, "index")
  end

  get "/:page" when page in ["gallery", "gallery-image", "index", "solo-image"] do
    render_template(conn, page)
  end

  def render_template(conn, name) do
    name
    |> View.within_layout([])
    |> respond(conn)
  end

  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    send_resp(conn, 404, "oops")
  end
end
