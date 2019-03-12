defmodule Gnuplot.MixProject do
  use Mix.Project

  def project do
    [
      app: :gnuplot,
      version: "0.19.70",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/devstopfix/gnuplot-elixir",
      dialyzer: [
        flags: [],
        plt_add_apps: [:mix],
        remove_defaults: [:unknown]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.2", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end
end
