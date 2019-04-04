defmodule Polynomial do
  @moduledoc """
  Polynomials graphs from Wikipedia.

  https://en.wikipedia.org/wiki/Polynomial#Graphs
  """

  def png, do: Path.join("/tmp/", "polynomial.PNG")

  def target,
    do: [
      [:set, :term, :pngcairo, :size, '400,400', :font, "Times,14"],
      [:set, :output, png()]
    ]

  def style,
    do: [
      ~w(set style line 1 lw 3 lc '#DD0000')a,
      ~w(set style line 2 lw 3 lc '#000000')a,
      ~w(set style line 3 lw 1 lc '#CECECE')a,
      ~w(set xzeroaxis ls 2)a,
      ~w(set yzeroaxis ls 2)a,
      ~w(set grid ls 3)a,
      [:set, :xrange, -5..4],
      [:set, :yrange, -4..6],
      [:set, :format, :x, ""],
      [:set, :format, :y, ""],
      ~w(set border ls 3)a
    ]

  def commands,
    do: [
      [:set, :title, "Wikipedia Polynomial"],
      [
        :plot,
        '((x**3)/4)+(3*(x**2)/4)-(3*x/2)-2',
        :ls,
        1,
        :notitle
      ]
    ]

  def plot, do: {:ok, _} = Gnuplot.plot(target() ++ style() ++ commands())
end

# mix run examples/polynomial.exs
Polynomial.plot()
