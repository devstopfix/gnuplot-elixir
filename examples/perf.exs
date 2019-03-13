defmodule Perf do
  alias Gnuplot, as: G

  @moduledoc false

  def png, do: Path.join("docs", "perf.PNG")

  def target,
    do: [
      [:set, :term, :png, :size, '512,512', :font, "/Library/Fonts/FiraCode-Medium.otf", 12],
      [:set, :output, png()]
    ]

  def commands,
    do: [
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
    ]

  def data do
    points = [1, 10, 100, 1000, 10_000, 100_000, 1_000_000]
    clojure_gui = [1.487, 1.397, 1.400, 1.381, 1.440, 5.784, 49.275]
    elixir_gui = [0.005, 0.010, 0.004, 0.059, 0.939, 5.801, 43.464]
    elixir_png = [0.002, 0.010, 0.049, 0.040, 0.349, 4.091, 41.521]
    for ds <- [clojure_gui, elixir_gui, elixir_png], do: Enum.zip(points, ds)
  end

  def plot, do: G.plot(target() ++ commands(), data())
end

# mix run examples/perf.exs
Perf.plot()
