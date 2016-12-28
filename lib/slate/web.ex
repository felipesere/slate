defmodule Web do
  defmacro __using__(_opts) do
    quote do
      def redirect(conn, [to: target]) do
        conn
        |> Plug.Conn.put_resp_header("location", target)
        |> Plug.Conn.send_resp(302, "Redirecting...")
        |> Plug.Conn.halt
      end

      def not_found(conn) do
        Plug.Conn.send_resp(conn, 404, "oops")
      end

      defp respond(body, conn), do: Plug.Conn.send_resp(conn, 200, body)
    end
  end
end
