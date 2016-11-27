ExUnit.start()

defmodule WebCase do
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case
      use Plug.Test

      Logger.configure(level: :error)

      def get(path), do: conn(:get, path) |> Slate.Router.call([])
      def body(conn), do: conn.resp_body

      # For Floki
      def children(elements) when is_list(elements), do: Enum.flat_map(elements, &children(&1))
      def children({_, _, x}), do: x

      def present([]), do: false
      def present(_elements), do: true
    end
  end
end

Ecto.Adapters.SQL.Sandbox.mode(Slate.Catalog, :manual)
