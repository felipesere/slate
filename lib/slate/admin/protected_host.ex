defmodule Slate.Admin.ProtectedHost do
  def init(opts) do
    # Allow configuration through normal config.exs
    opts
  end

  def call(conn, [host: protected_host]) do
    [host] = Plug.Conn.get_req_header(conn, "host")
    scheme = conn.scheme |> Atom.to_string()
    if host != protected_host do
      IO.puts "Arriving from #{host}, heading to #{protected_host}"
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
