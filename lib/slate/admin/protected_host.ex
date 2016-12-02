defmodule Slate.Admin.ProtectedHost do
  def init(opts), do: opts

  def call(conn, [host: protected_host]) do
    [host] = Plug.Conn.get_req_header(conn, "host")

    if host != protected_host do
      redirect(conn, to: protected_host <> conn.request_path)
    else
      conn
    end
  end

  defp redirect(conn, [to: target]) do
    conn
    |> Plug.Conn.put_status(301)
    |> Plug.Conn.put_resp_header("location", target)
    |> Plug.Conn.halt
  end
end
