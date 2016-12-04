ExUnit.start()

defmodule WebCase do
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case
      use Plug.Test

      @session Plug.Session.init(
                                 store: :cookie,
                                 key: "_app",
                                 signing_salt: "yadayada"
                               )

      Logger.configure(level: :error)

      def get(path) do
        conn(:get, path)
        |> add_session()
        |> Slate.Router.call([])
      end
      def body(conn), do: conn.resp_body

      def add_session(conn) do
        conn
        |> Map.put(:secret_key_base, String.duplicate("abcdefgh",8))
        |> Plug.Session.call(@session)
      end

      def authenticated(conn) do
        conn
        |> add_session()
        |> Plug.Conn.fetch_session
        |> Plug.Conn.put_session(:authenticated, true)
      end

      def children(elements) when is_list(elements), do: Enum.flat_map(elements, &children(&1))
      def children({_, _, x}), do: x

      def present([]), do: false
      def present(_elements), do: true
    end
  end
end

Ecto.Adapters.SQL.Sandbox.mode(Slate.Catalog, :manual)
