defmodule Mix.Tasks.Gnuplot.Plots do
  use Mix.Task

  @moduledoc false

  defmacro execute(name, units \\ :millisecond, do: yield) do
    quote do
      start = System.monotonic_time(unquote(units))
      result = unquote(yield)
      time_spent = System.monotonic_time(unquote(units)) - start
      IO.puts("Executed #{unquote(name)} in #{time_spent} #{unquote(units)}")
      result
    end
  end

  alias Gnuplot, as: G

  defp plot_file(target, cmds, datasets \\ [], xy \\ '512,256') do
    cmdf =
      Enum.concat(
        [
          [:set, :term, :png, :size, xy, :font, "/Library/Fonts/FiraCode-Medium.otf", 12],
          [:set, :output, target]
        ],
        cmds
      )

    execute target do
      {:ok, _} = G.plot(cmdf, datasets)
    end
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

  defp speed do
    points = [1, 10, 100, 1000, 10_000, 100_000, 1_000_000]
    clojure_gui = [1.487, 1.397, 1.400, 1.381, 1.440, 5.784, 49.275]
    elixir_gui = [0.005, 0.010, 0.004, 0.059, 0.939, 5.801, 43.464]
    elixir_png = [0.002, 0.010, 0.049, 0.040, 0.349, 4.091, 41.521]
    datasets = for ds <- [clojure_gui, elixir_gui, elixir_png], do: Enum.zip(points, ds)

    plot_file(
      "docs/speed.PNG",
      [
        [:set, :title, "Render scatter plot"],
        [:set, :xlabel, "Points"],
        [:set, :ylabel, "Elapsed (s)"],
        ~w(set key left top)a,
        ~w(set logscale xy)a,
        ~w(set grid xtics ytics)a,
        ~w(set style line 1 lw 4 lc '#63b132')a,
        ~w(set style line 2 lw 4 lc '#421C52')a,
        ~w(set style line 3 lw 4 lc '#732C7B')a,
        [
          :plot,
          G.list(
            ["-", :title, "Clojure GUI", :with, :lines, :ls, 1],
            ["-", :title, "Elixir GUI", :with, :lines, :ls, 2],
            ["-", :title, "Elixir PNG", :with, :lines, :ls, 3]
          )
        ]
      ],
      datasets,
      '512,512'
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
      ]
    )
  end

  defp atan_sin do
    plot_file(
      "docs/atan_sin.PNG",
      [
        ~w(set autoscale)a,
        ~w(set samples 800)a,
        [
          :plot,
          '[-30:20]',
          'sin(x*20)*atan(x)'
        ]
      ]
    )
  end

  def stress(n, gui \\ false) do
    if gui do
      execute(inspect(n)) do
        {:ok, _} =
          G.plot(
            [
              [:set, :key, :left, :top],
              [:plot, "-", :with, :points]
            ],
            [
              for(i <- 0..n, do: [i / n, i * :rand.uniform()])
            ]
          )
      end
    else
      plot_file(
        "docs/stress" <> to_string(n) <> ".PNG",
        [
          [:set, :key, :left, :top],
          [:plot, "-", :with, :points]
        ],
        [
          for(i <- 0..n, do: [i / n, i * :rand.uniform()])
        ],
        '2048,1920'
      )
    end
  end

  @shortdoc "Generate plots of the README"
  def run(_) do
    atan_sin()
    rand()
    sine()
    speed()
    # stress(1)
    # stress(10)
    # stress(100)
    # stress(1_000)
    # stress(10_000)
    # stress(100_000)
    # stress(1_000_000)
  end
end
