defmodule Web do
  defmacro __using__(_opts) do
    quote do
      import Plug.Conn, only: [put_resp_header: 3, send_resp: 3, halt: 1]

      def redirect(conn, [to: target]) do
        conn
        |> put_resp_header("location", target)
        |> send_resp(302, "Redirecting...")
        |> halt
      end

      def not_found(conn) do
        send_resp(conn, 404, "oops")
      end

      defp respond(body, conn), do: send_resp(conn, 200, body)
    end
  end
end
