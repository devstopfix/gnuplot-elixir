defmodule Stress do
  alias Gnuplot, as: G

  @moduledoc "https://github.com/aphyr/gnuplot/blob/master/test/gnuplot/core_test.clj#L24"

  def png, do: Path.join(System.get_env("TMPDIR"), "stress.PNG")

  def target,
    do: [
      [:set, :term, :png, :size, '2048,1920'],
      [:set, :output, png()]
    ]

  def commands,
    do: [
      [:set, :title, "Noise plot"],
      ~w(set key left top)a,
      [:plot, "-", :with, :points]
    ]

  def data(n \\ 500_000),
    do: [
      for(i <- 0..n, do: [i / n, i * :rand.uniform()])
    ]

  def plot, do: G.plot(target() ++ commands(), data())
end

# > time mix run examples/stress.exs && open "$TMPDIR"/stress.PNG
#
# real	0m21.498s
# user	0m11.204s
# sys	   0m3.393s

Stress.plot()
