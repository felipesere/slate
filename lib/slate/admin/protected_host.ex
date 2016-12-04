defmodule Slate.Admin.ProtectedHost do
  require Logger
  def init(opts) do
    # Allow configuration through normal config.exs
    opts
  end

  def call(conn, opts) do
    [host] = Plug.Conn.get_req_header(conn, "host")
    scheme = Keyword.get(opts, :scheme, Atom.to_string(conn.scheme))
    protected_host = Keyword.fetch!(opts, :host)
    if host != protected_host do
      Logger.info("Arriving from #{host}, heading to #{protected_host}")
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
