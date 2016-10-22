defmodule Slate do
  use Application

  def start(_type, _args) do
    IO.puts "Starting..."
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Slate.Router, [], [port: 80])
    ]

    opts = [strategy: :one_for_one, name: Slate.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
