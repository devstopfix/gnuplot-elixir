defmodule BarChart do
  import Gnuplot

  @moduledoc "Chart from https://stackoverflow.com/a/11551808/3366"

  def run do
    chart = [
      [:set, :term, :png, :size, '512,512'],
      [:set, :output, Path.join("/tmp", "barchart.PNG")],
      [:set, :boxwidth, 0.5],
      ~w(set style fill solid)a,
      [:plot, "-", :using, '1:3:xtic(2)', :with, :boxes]
    ]

    dataset = [[0, "label", 100], [1, "label2", 450], [2, "bar label", 75]]

    plot(chart, [dataset])
  end
end

# mix run examples/so327576.exs && open /tmp/barchart.PNG
BarChart.run()
