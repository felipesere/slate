defmodule Slate.Admin.Login do
  use Web
  use Plug.Router
  use Plug.Builder
  alias Slate.Admin.Credentials

  plug :match
  plug :dispatch

  get "/" do
    "login"
    |> Admin.View.within_layout()
    |> respond(conn)
  end

  post "/" do
    conn = conn |> fetch_query_params

    %{"username" => user, "password" => password} = conn.body_params

    if Credentials.check(user, password) do
      conn
      |> Plug.Conn.fetch_session
      |> Plug.Conn.put_session(:authenticated, true)
      |> redirect(to: "/admin")
    else
      conn
      |> redirect(to: "/admin/login")
    end
  end

  defp respond(body, conn), do: send_resp(conn, 200, body)

  match _ do
    not_found(conn)
  end

  def not_found(conn) do
    send_resp(conn, 404, "oops")
  end
end
