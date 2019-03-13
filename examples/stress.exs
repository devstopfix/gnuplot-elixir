defmodule Stress do
  alias Gnuplot, as: G

  @moduledoc "https://github.com/aphyr/gnuplot/blob/master/test/gnuplot/core_test.clj#L24"

  def png(n), do: Path.join("/tmp", "stress" <> to_string(n) <> ".PNG")

  def target(n),
    do: [
      [:set, :term, :png, :size, '2048,1920', :font, "/Library/Fonts/FiraCode-Medium.ttf", 12],
      [:set, :output, png(n)]
    ]

  def commands,
    do: [
      [:set, :title, "Noise plot"],
      ~w(set key left top)a,
      [:plot, "-", :with, :points]
    ]

  def data(n),
    do:
      Stream.unfold(0, fn i ->
        if i <= n do
          {[i / n, i * :rand.uniform()], i + 1}
        else
          nil
        end
      end)

  def plot(n), do: G.plot(target(n) ++ commands(), [data(n)])
end

# time mix run examples/stress.exs

for n <- [1, 10, 100, 1_000, 10_000, 100_000, 1_000_000] do
  {t, _} = :timer.tc(fn -> Stress.plot(n) end)
  IO.inspect([n, Float.round(t / 1000.0 / 1000.0, 3)])
end
