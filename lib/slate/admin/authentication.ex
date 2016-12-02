defmodule Slate.Admin.Authentication do
  def init(options) do
    options
  end

  def call(conn, [username: user, password: pwd]) do
    auth_header = Plug.Conn.get_req_header(conn, "authorization")

    if auth_header == [] do
      deny(conn)
    else
      [username, password] = extract_credentials(auth_header)
      if username == user && password == pwd do
        conn
      else
        deny(conn)
      end
    end
  end

  defp extract_credentials([auth_header]) do
    auth_header
    |> String.replace_prefix("Basic ", "")
    |> Base.decode64!
    |> String.split(":")
  end

  defp deny(conn) do
    conn
    |> Plug.Conn.send_resp(401, "Unauthorized")
    |> Plug.Conn.halt
  end
end
