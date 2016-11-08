defmodule Mix.Tasks.BuildAssets do
  use Mix.Task

  def run(_), do: run
  def run do
    System.cmd("sass", ["--sourcemap=none", "style/main.css.scss", "priv/static/main.css"], into: IO.stream(:stdio, :line))
  end
end
