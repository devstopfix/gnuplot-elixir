defmodule Perf do
  alias Gnuplot, as: G

  @moduledoc false

  def png, do: Path.join("docs", "perf.PNG")

  def target,
    do: [
      [:set, :term, :pngcairo, :size, '640,512', :font, "Source Code Pro,12"],
      [:set, :output, png()]
    ]

  def commands,
    do: [
      [:set, :title, "Time to render scatter plots"],
      [:set, :xlabel, "Points in plot"],
      [:set, :ylabel, "Elapsed (s)"],
      ~w(set key left top)a,
      ~w(set logscale xy)a,
      ~w(set grid xtics ytics)a,
      ~w(set style line 1 lw 2 lc '#63b132')a,
      ~w(set style line 2 lw 2 lc '#2C001E')a,
      ~w(set style line 3 lw 2 lc '#5E2750')a,
      ~w(set style line 4 lw 2 lc '#E95420')a,
      ~w(set style line 5 lw 4 lc '#77216F')a,
      [
        :plot,
        G.list(
          ["-", :title, "Clojure GUI", :with, :lines, :ls, 1],
          ["-", :title, "Elixir GUI", :with, :lines, :ls, 2],
          ["-", :title, "Elixir PNG", :with, :lines, :ls, 3],
          ["-", :title, "Elixir t2.m", :with, :lines, :ls, 4],
          ["-", :title, "Elixir Stream", :with, :lines, :ls, 5]
        )
      ]
    ]

  def data do
    points = [1, 10, 100, 1000, 10_000, 100_000, 1_000_000]
    clojure_gui = [1.487, 1.397, 1.400, 1.381, 1.440, 5.784, 49.275]
    elixir_gui = [0.005, 0.010, 0.004, 0.059, 0.939, 5.801, 43.464]
    elixir_png = [0.018, 0.001, 0.012, 0.052, 0.348, 3.494, 35.505]
    ubuntu_t2m = [0.004, 0.002, 0.001, 0.008, 0.211, 1.873, 19.916]
    ubuntu_stream = [0.002, 0.001, 0.001, 0.009, 0.204, 1.279, 12.858]

    for ds <- [clojure_gui, elixir_gui, elixir_png, ubuntu_t2m, ubuntu_stream],
        do: Enum.zip(points, ds)
  end

  def plot, do: G.plot(target() ++ commands(), data())
end

# mix run examples/perf.exs
Perf.plot()
