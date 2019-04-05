defmodule Rand do
  import Gnuplot

  @moduledoc false

  def png, do: Path.join("docs", "rand.PNG")

  def target,
    do: [
      [:set, :term, :pngcairo, :size, '512,256', :font, "Fira Sans,12"],
      [:set, :output, png()]
    ]

  def commands,
    do: [
      ~w(set key left top)a,
      ~w(set style line 1 lc rgb '#77216F' pt 13)a,
      ~w(set style line 2 lc rgb '#599B2B' pt 2)a,
      plots([
        ["-", :title, "uniform", :with, :points, :ls, 1],
        ["-", :title, "normal", :with, :points, :ls, 2]
      ])
    ]

  def data,
    do: [
      for(n <- 0..99, do: [n, n * :rand.uniform()]),
      for(n <- 0..99, do: [n, n * :rand.normal()])
    ]

  def draw, do: plot(target() ++ commands(), data())
end

# mix run examples/rand.exs
{:ok, _} = Rand.draw()
