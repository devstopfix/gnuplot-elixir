defmodule AtanSin do
  import Gnuplot

  @moduledoc "http://gnuplot.sourceforge.net/demo/simple.7.gnu"

  def png, do: Path.join("docs", "atan_sin.PNG")

  def target,
    do: [
      [:set, :term, :png, :size, '512,256', :font, "/Library/Fonts/FiraCode-Medium.ttf", 12],
      [:set, :output, png()]
    ]

  def commands,
    do: [
      ~w(set autoscale)a,
      ~w(set samples 800)a,
      [
        :plot,
        -30..20,
        'sin(x*20)*atan(x)'
      ]
    ]

  def plot, do: plot(target() ++ commands())
end

# mix run examples/atan_sin.exs
AtanSin.plot()
