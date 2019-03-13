defmodule Stress do
  alias Gnuplot, as: G

  @moduledoc "https://github.com/aphyr/gnuplot/blob/master/test/gnuplot/core_test.clj#L24"

  def png(n), do: Path.join(System.get_env("TMPDIR"), "stress" <> to_string(n) <> ".PNG")

  def target(n),
    do: [
      [:set, :term, :png, :size, '2048,1920'],
      [:set, :output, png(n)]
    ]

  def commands,
    do: [
      [:set, :title, "Noise plot"],
      ~w(set key left top)a,
      [:plot, "-", :with, :points]
    ]

  def data(n),
    do: [
      for(i <- 0..n, do: [i / n, i * :rand.uniform()])
    ]

  def plot(n), do: G.plot(target(n) ++ commands(), data(n))
end

# > time mix run examples/stress.exs

for n <- [1, 10, 100, 1_000, 10_000, 100_000, 1_000_000] do
  {t, _} = :timer.tc(fn -> Stress.plot(n) end)
  IO.inspect([n, t / 1000.0])
end
