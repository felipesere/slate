defmodule Slate.Admin.ProtectedHost do
  def init(opts), do: opts

  def call(conn, [host: protected_host]) do
    [host] = Plug.Conn.get_req_header(conn, "host")

    conn
    |> Plug.Conn.put_status(301)
    |> Plug.Conn.put_resp_header("location", protected_host)
    |> Plug.Conn.halt
  end
end
