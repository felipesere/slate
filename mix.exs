defmodule Slate.Mixfile do
  use Mix.Project

  def project do
    [app: :slate,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :cowboy, :plug],
     mod: {Slate, []}]
  end

  defp deps do
    [
     {:cowboy, "~> 1.0.4"},
     {:plug, "~> 1.2.2"}
   ]
  end
end
