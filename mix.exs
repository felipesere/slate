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
    [applications: [:logger, :cowboy, :plug, :hackney, :ex_aws],
     mod: {Slate, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.4"},
      {:plug, "~> 1.2.2"},
      {:ex_aws, "~> 1.0.0-rc.3"},
      {:poison, "~> 2.0"},
      {:hackney, "~> 1.6"},
      {:sweet_xml, "~> 0.6.2"}
    ]
  end
end
