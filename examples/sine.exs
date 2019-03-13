defmodule Sine do
  import Gnuplot

  @moduledoc "http://gnuplot.sourceforge.net/demo/simple.7.gnu"

  def png, do: Path.join("docs", "sine.PNG")

  def target,
    do: [
      [:set, :term, :png, :size, '512,256', :font, "/Library/Fonts/FiraCode-Medium.ttf", 12],
      [:set, :output, png()]
    ]

  def commands,
    do: [
      ~w(set style line 1 lw 2 lc '#732C7B')a,
      [
        :plot,
        'sin(x)',
        :title,
        "Sine Wave",
        :ls, 1
      ]
    ]

  def plot, do: plot(target() ++ commands())
end

# mix run examples/sine.exs
Sine.plot()
