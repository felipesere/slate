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
      accept(conn)
    else
      deny(conn)
    end
  end

  defp accept(conn) do
    conn
    |> Plug.Conn.fetch_session
    |> Plug.Conn.put_session(:authenticated, true)
    |> redirect(to: "/admin")
  end

  defp deny(conn), do: redirect(conn, to: "/admin/login")

  match _ do
    not_found(conn)
  end
end
