defmodule AtanSin do
  import Gnuplot

  @moduledoc "http://gnuplot.sourceforge.net/demo/simple.7.gnu"

  def png, do: Path.join("assets", "atan_sin_dataset.png")

  def target,
    do: [
      [:set, :term, :png, :size, '512,256', :font, "/Library/Fonts/FiraCode-Medium.ttf", 12],
      [:set, :output, png()]
    ]

  def commands,
    do: [
      [
        :plot,
        "-",
        :with,
        :lines,
        :title,
        "sin(x*20)*atan(x)"
      ]
    ]

  def plot, do: plot(target() ++ commands(), [dataset()])

  defp dataset do
    Enum.map(ffor(-30, 20, 800), fn x -> [x, :math.sin(x * 20) * :math.atan(x)] end)
  end

  # defp dataset2 do
  #   for x <- -30_000..20_000,
  #       do: [x / 1000.0, :math.sin(x * 20 / 1000.0) * :math.atan(x / 1000.0)]
  # end

  defp ffor(min, max, step), do: for(x <- min..max, dx <- 0..step, do: x + dx / step)
end

# mix run examples/atan_sin_dataset.exs
AtanSin.plot()
