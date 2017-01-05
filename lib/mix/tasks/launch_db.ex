defmodule Mix.Tasks.LaunchDb do
  use Mix.Task

  def run(opts) do
    command = Enum.find(opts, "start", &( &1 in ["start", "stop"]))
    execute("pg_ctl", "-D /usr/local/var/postgres -l /usr/local/var/postgres/server.log #{command}")
  end

  defp execute(command, args) do
    args = String.split(args)
    System.cmd(command, args, into: IO.stream(:stdio, :line))
  end
end
