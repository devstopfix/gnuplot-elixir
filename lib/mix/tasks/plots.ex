defmodule Mix.Tasks.Gnuplot.Plots do
  use Mix.Task

  @moduledoc false

  alias Gnuplot, as: G

  defp plot_file(target, cmds, datasets) do
    cmdf =
      Enum.concat(
        [[:set, :term, :png, :size, '512,256'], [:set, :output, target]],
        cmds
      )

    {:ok, _} = G.plot(cmdf, datasets)
  end

  defp rand do
    plot_file(
      "docs/rand.PNG",
      [
        [:set, :key, :left, :top],
        [
          :plot,
          G.list(
            ["-", :title, "uniform", :with, :points],
            ["-", :title, "normal", :with, :points]
          )
        ]
      ],
      [
        for(n <- 0..196, do: [n, n * :rand.uniform()]),
        for(n <- 0..196, do: [n, n * :rand.normal()])
      ]
    )
  end

  defp sine do
    plot_file(
      "docs/sine.PNG",
      [
        [
          :plot,
          'sin(x)',
          :title,
          "Sine Wave"
        ]
      ],
      []
    )
  end

  @shortdoc "Generate plots of the README"
  def run(_) do
    rand()
    sine()
  end
end
