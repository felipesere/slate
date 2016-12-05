defmodule Web do
  defmacro __using__(_opts) do
    quote do
      def redirect(conn, [to: target]) do
        conn
        |> Plug.Conn.put_resp_header("location", target)
        |> Plug.Conn.send_resp(302, "Redirecting...")
        |> Plug.Conn.halt
      end
    end
  end
end
