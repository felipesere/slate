defmodule Slate.Router do
  use Plug.Router
  use Plug.Builder

  plug Plug.Static, at: "/public", from: :slate, only: ~w(main.css normalize.css images)
  plug :match
  plug :dispatch

  get "/" do
    render_template(conn, "index")
  end

  def render_template(conn, name) do
    name
    |> expand
    |> template
    |> respond(conn)
  end

  defp expand(name), do: Path.expand("lib/templates/#{name}.html.eex")
  defp template(path), do: EEx.eval_file(path)
  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    send_resp(conn, 404, "oops")
  end
end
