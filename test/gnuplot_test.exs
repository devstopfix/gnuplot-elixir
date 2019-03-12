defmodule GnuplotTest do
  use ExUnit.Case
  alias Gnuplot, as: G
  alias Gnuplot.Commands, as: C

  test "List of commands" do
    assert "set xtics off;\nset ytics off" ==
             C.format([[:set, :xtics, :off], [:set, :ytics, :off]])
  end

  test "Word sigil" do
    assert "set xtics off;\nset ytics off" ==
             C.format([~w(set xtics off)a, ~w(set ytics off)a])
  end

  test "String literals" do
    assert "plot cos(x)" == C.format([[:plot, 'cos(x)']])
  end

  test "Strings and literals" do
    assert "plot sin(x) title \"Sine Wave\"" == C.format([[:plot, 'sin(x)', :title, "Sine Wave"]])
  end

  test "Plot range" do
    assert "plot [0:5]" == C.format([[:plot, 0..5]])
  end

  test "Title string" do
    assert "set title \"simple space\"" == C.format([[:set, :title, "simple space"]])
  end

  test "Title apostrophe" do
    assert "set title \"simple's\"" == C.format([[:set, :title, "simple's"]])
  end

  @tag gnuplot: true
  test "Gnuplot is installed" do
    assert {:ok, path} = G.gnuplot_bin()
    assert File.exists?(path)
  end

  @tag gnuplot: true
  test "Simple plot" do
    plot = [[:plot, "-", :with, :lines]]
    expected = "plot \"-\" with lines"
    assert {:ok, expected} == G.plot(plot, [[[0, 0], [1, 2], [2, 4]]])
  end

  @tag gnuplot: true
  test "Scatter plot" do
    dataset = for _ <- 0..1000, do: [:rand.uniform(), :rand.normal()]
    plot = [[:set, :title, "rand uniform vs normal"], [:plot, "-", :with, :points]]
    assert {:ok, _} = G.plot(plot, [dataset])
  end

  test "Write PNG" do
    {tmp, 0} = System.cmd("mktemp", [])
    png = String.trim_trailing(tmp, "\n") <> ".PNG"

    assert {:ok, _} =
             G.plot(
               [[:set, :term, :png], [:set, :output, png], [:plot, "-", :with, :lines]],
               [[[0, 0], [1, 1]]]
             )

    assert Enum.any?(1..10, fn _ ->
             :timer.sleep(10)
             File.exists?(png)
           end)
  end
end
