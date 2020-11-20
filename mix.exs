defmodule Gnuplot.MixProject do
  use Mix.Project

  @source_url "https://github.com/devstopfix/gnuplot-elixir"

  def project do
    [
      app: :gnuplot,
      version: "1.20.320",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: "Interface between Elixir and Gnuplot graphing library",
      deps: deps(),
      docs: docs(),
      dialyzer: [
        flags: [],
        plt_add_apps: [:mix],
        remove_defaults: [:unknown]
      ],
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.23.0"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["James Every"],
      licenses: ["EPL-2.0"],
      links: %{
        "GitHub" => @source_url,
        "Gnuplot" => "http://www.gnuplot.info/",
        "Travis CI" => "https://travis-ci.org/devstopfix/gnuplot-elixir"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      assets: "assets",
      source_url: @source_url,
      extras: [
        "README.md"
      ]
    ]
  end
end
