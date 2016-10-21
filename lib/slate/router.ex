defmodule Slate.Router do
  use Plug.Router
  use Plug.Builder

  plug Plug.Static, at: "/public", from: :slate, only: ~w(main.css normalize.css)
  plug :match
  plug :dispatch

  get "/" do
    response = EEx.eval_string("<html><head></head><body>Hello <%= thing %></body></html>", [thing: "World!"])
    send_resp(conn, 200, response)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
