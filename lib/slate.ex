defmodule Slate do
  use Application

  def start(_type, _args) do
    IO.puts "Starting..."
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Slate.Router, [], [port: port()]),
      worker(Slate.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Slate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def port do
    case System.get_env("PORT") do
      nil -> 4000
      x -> Integer.parse(x) |> elem(0)
    end
  end
end
