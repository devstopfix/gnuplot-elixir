defmodule Sine do
  import Gnuplot

  @moduledoc "http://gnuplot.sourceforge.net/demo/simple.7.gnu"

  def png, do: Path.join("docs", "sine.PNG")

  def target,
    do: [
      [:set, :term, :pngcairo, :size, '512,256', :font, "Fira Sans"],
      [:set, :output, png()]
    ]

  def commands,
    do: [
      ~w(set style line 1 linecolor rgb '#77216F' linetype 1 linewidth 2)a,
      ~w(unset xzeroaxis)a,
      ~w(unset yzeroaxis)a,
      ~w(set ytics -1,1)a,
      [
        :plot,
        'sin(x)',
        :title,
        "Sine Wave",
        :ls,
        1
      ]
    ]

  def plot, do: plot(target() ++ commands())
end

# mix run examples/sine.exs
Sine.plot()
