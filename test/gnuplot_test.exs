defmodule GnuplotTest do
  use ExUnit.Case
  alias Gnuplot, as: G
  alias Gnuplot.Commands, as: C

  test "Empty setter" do
    assert "set" == C.format([:set])
  end

  test "Lists" do
    assert "set xtics off;\nset ytics off" ==
             C.format([[:set, :xtics, :off], [:set, :ytics, :off]])
  end

  test "Plot range" do
    assert "plot [0:5]" == C.format([[:plot, 0..5]])
  end

  test "Title string" do
    assert "set title 'simple'" == C.format([[:set, :title, "simple"]])
  end

  test "Title apostrophe" do
    assert "set title 'simple\\'s'" == C.format([[:set, :title, "simple's"]])
  end

  @tag gnuplot: true
  test "Gnuplot is installed" do
    assert {:ok, path} = G.gnuplot_bin()
    assert File.exists?(path)
  end

  @tag gnuplot: true
  test "Simple plot" do
    plot = [[:plot, G.list(["-", :with, :lines])]]
    expected = "plot '-' with lines"
    assert {:ok, expected} == G.plot(plot, [[[0, 0], [1, 2], [2, 4]]])
  end

  @tag gnuplot: true
  test "Scatter plot" do
    dataset = for _ <- 0..1000, do: [:rand.uniform(), :rand.normal()]
    plot = [[:set, :title, "rand uniform vs normal"], [:plot, G.list(["-", :with, :points])]]
    assert {:ok, _} = G.plot(plot, [dataset])
  end

  # def numbers(n), do: 0..n |> Enum.map(fn x -> x / n end)

  # @tag gnuplot: true
  # test "Sine wave" do
  #   dataset = 100 |> numbers() |> Enum.map(fn x -> [x, :math.sin(x / 10.0)] end)

  #   plot = [[:plot, G.list(["-", :with, :lines])]]
  #   expected = "plot '-' with lines"
  #   assert {:ok, expected} == G.plot(plot, [dataset])
  # end

  # @tag gnuplot: true
  # test "Scatter plots" do
  #   d1 = for n <- 0..100, do: [n, n * :rand.uniform()]
  #   d2 = for n <- 0..100, do: [n, n * :rand.normal()]
  #   plot = [[:plot, G.list(["-", :with, :points], ["-", :with, :points])]]
  #   assert {:ok, _} = G.plot(plot, [d1, d2])
  # end

  test "Write PNG" do
    {tmp, 0} = System.cmd("mktemp")
    png = String.trim_trailing(tmp, "\n") <> ".PNG"

    # assert {:ok, _} == G.plot([
    #   # [:a, :=, 0.9],
    #   [:plot, G.list(["-", :with, :lines])]], [])

  end

end
