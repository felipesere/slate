defmodule Slate.Admin.Authentication do
  alias Slate.Admin.Credentials
  def init(opts) do

    paths = Keyword.get(opts, :exclude, [])
    [exclude: paths]
  end

  def call(conn, opts) do
    paths = Keyword.get(opts, :exclude, [])
    if needs_no_auth?(conn, paths) || has_cookie?(conn) || has_header_auth?(conn) do
      conn
    else
      deny(conn)
    end
  end

  defp needs_no_auth?(conn, paths), do: conn.request_path in paths

  defp has_cookie?(conn) do
    conn
    |> Plug.Conn.fetch_session
    |> Plug.Conn.get_session(:authenticated)
  end

  defp has_header_auth?(conn) do
    with [auth_header] <- Plug.Conn.get_req_header(conn, "authorization"),
         [username, password] <- extract_credentials(auth_header)
         do 
           Credentials.check(username, password)
    else
      _ -> false
    end
  end

  defp extract_credentials(auth_header) do
    auth_header
    |> String.replace_prefix("Basic ", "")
    |> Base.decode64!
    |> String.split(":")
  end

  defp deny(conn) do
    conn
    |> Plug.Conn.put_resp_header("x-redirect-reason","auth-denied")
    |> Plug.Conn.put_resp_header("location", "/admin/login")
    |> Plug.Conn.send_resp(302, "Unauthorized")
    |> Plug.Conn.halt
  end
end
