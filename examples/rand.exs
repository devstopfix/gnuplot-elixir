defmodule Rand do
  alias Gnuplot, as: G

  @moduledoc false

  def png, do: Path.join("docs", "rand.PNG")

  def target,
    do: [
      [:set, :term, :png, :size, '512,256', :font, "/Library/Fonts/FiraCode-Medium.otf", 12],
      [:set, :output, png()]
    ]

  def commands,
    do: [
      ~w(set key left top)a,
      [
        :plot,
        G.list(
          ["-", :title, "uniform", :with, :points],
          ["-", :title, "normal", :with, :points]
        )
      ]
    ]

  def data,
    do: [
      for(n <- 0..196, do: [n, n * :rand.uniform()]),
      for(n <- 0..196, do: [n, n * :rand.normal()])
    ]

  def plot, do: G.plot(target() ++ commands(), data())
end

# mix run examples/rand.exs
Rand.plot()
