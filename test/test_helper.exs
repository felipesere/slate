ExUnit.start()

defmodule WebCase do
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case
      use Plug.Test

      Logger.configure(level: :error)

      def get(path), do: conn(:get, path) |> Slate.Router.call([])
      def body(conn), do: conn.resp_body
    end
  end
end
