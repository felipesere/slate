defmodule Slate.Admin.ProtectedHost do
  def init(opts), do: opts

  def call(conn, [host: protected_host]) do
    [host] = Plug.Conn.get_req_header(conn, "host")
    scheme = conn.scheme |> Atom.to_string()
    if host != protected_host do
      redirect(conn, to: scheme <> "://" <> protected_host <> conn.request_path)
    else
      conn
    end
  end

  defp redirect(conn, [to: target]) do
    conn
    |> Plug.Conn.put_resp_header("location", target)
    |> Plug.Conn.send_resp(301, "Redirecting...")
    |> Plug.Conn.halt
  end
end
