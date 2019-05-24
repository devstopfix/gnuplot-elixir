defmodule Gnuplot.MixProject do
  use Mix.Project

  def project do
    [
      app: :gnuplot,
      version: "1.19.96",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: "Interface between Elixir and Gnuplot graphing library",
      deps: deps(),
      dialyzer: [
        flags: [],
        plt_add_apps: [:mix],
        remove_defaults: [:unknown]
      ],
      package: package(),
      source_url: "https://github.com/devstopfix/gnuplot-elixir"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.5", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.19.0", only: :dev},
      {:mix_test_watch, "~> 0.9", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["James Every"],
      licenses: ["EPL-2.0"],
      links: %{
        "GitHub" => "https://github.com/devstopfix/gnuplot-elixir",
        "Gnuplot" => "http://www.gnuplot.info/",
        "Travis CI" => "https://travis-ci.org/devstopfix/gnuplot-elixir"
      }
    ]
  end
end
