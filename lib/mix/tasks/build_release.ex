defmodule Mix.Tasks.BuildRelease do
  use Mix.Task

  def run(_) do
    System.cmd("sass", ["--sourcemap=none", "style/main.css.scss", "priv/static/main.css"], into: IO.stream(:stdio, :line))
  end
end
