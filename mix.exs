defmodule Slate.Mixfile do
  use Mix.Project

  def project do
    [app: :slate,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_path(Mix.env),
     deps: deps()]
  end

  def application do
    [applications: [:logger, :tzdata, :cowboy, :plug, :hackney, :exfswatch, :postgrex, :ecto, :timex],
     mod: {Slate, []}]
  end

  defp deps do
    [
      {:postgrex, ">= 0.13.0"},
      {:ecto, "~> 2.1.0"},
      {:cowboy, "~> 1.0.4"},
      {:plug, "~> 1.3.0"},
      {:poison, "~> 3.0.0"},
      {:hackney, "~> 1.6"},
      {:sweet_xml, "~> 0.6.2"},
      {:exfswatch, "~> 0.3.0"},
      {:timex, "~> 3.0"},
      {:tzdata, "~> 0.5.0"},
      {:floki, "~> 0.12.0", only: [:test]},
      {:credo, "~> 0.5", only: [:dev, :test]}
    ]
  end

  defp elixirc_path(:test), do: ["lib/", "test/view/example"]
  defp elixirc_path(_), do: ["lib/"]
end
