defmodule GnuplotTest do
  use ExUnit.Case
  alias Gnuplot, as: G
  alias Gnuplot.Commands, as: C
  alias Gnuplot.Dataset, as: D

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

  test "Datasets" do
    input = [[[1, 1], [1, 2]], [[2, 3], [2, 4], [2, 5]]]
    expected = ["1 1", "\n", "1 2", "\ne\n", "2 3", "\n", "2 4", "\n", "2 5", "\ne\n"]

    assert expected ==
             input |> D.format_datasets() |> Enum.to_list()
  end

  test "Comma separated lists of plots using arity 2" do
    assert "plot a with lines,b with points" ==
             C.format([[:plot, G.list([:a, :with, :lines], [:b, :with, :points])]])
  end

  test "Comma separated lists of plots using arity 1 and sublists" do
    assert "plot a with lines,b with points" ==
             C.format([[:plot, G.list([[:a, :with, :lines], [:b, :with, :points]])]])
  end

  @tag gnuplot: true
  test "Gnuplot is installed" do
    assert {:ok, path} = Gnuplot.Bin.gnuplot_bin()
    assert File.exists?(path)
  end

  @tag gnuplot: true
  test "Simple plot with single dataset" do
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

  @tag gnuplot: true
  test "3d splot" do
    plot = [
      [:set, :xrange, -3..3],
      [:set, :yrange, -3..3],
      G.splots([['x**2+y**2'], ['x**2-y**2']])
    ]

    expected = "set xrange [-3:3];\nset yrange [-3:3];\nsplot x**2+y**2,x**2-y**2"
    assert {:ok, expected} == G.plot(plot)
  end

  @tag gnuplot: true
  test "Capture output" do
    plot = [~w(set terminal pngcairo)a, ~w(set output)a, [:plot, 'sin(x)', :title, "Sine Wave"]]
    assert {:ok, _} = G.plot(plot, [])

    data? = receive do
      {_, {:data, _}} -> :data
    after
      1_000 -> :timeout
    end
    assert :data == data?
  end

  test "Strings with spaces in datasets" do
    input = [[0, "label", 100], [1, "label2", 450], [2, "bar label", 75]]
    expected = ["0 label 100", "\n", "1 label2 450", "\n", "2 \"bar label\" 75", "\ne\n"]

    assert expected ==
             [input] |> D.format_datasets() |> Enum.to_list()
  end

  test "Multiplot with two plot(s)" do
    input = [[:set, :multiplot, :layout, '2,1'], [:plot, 'sin(x)'], [:plot, 'cos(x)']]
    expected = "set multiplot layout 2,1;\nplot sin(x);\nplot cos(x)"

    assert expected == C.format(input)
  end

  test "Multiplot with plots" do
    input = [[:set, :multiplot, :layout, '2,1'], G.plots([['sin(x)'], ['cos(x)']])]
    expected = "set multiplot layout 2,1;\nplot sin(x),cos(x)"

    assert expected == C.format(input)
  end

  test "Multiplot with list" do
    input = [[:set, :multiplot, :layout, '2,1'], [:plot, G.list([['sin(x)'], ['cos(x)']])]]
    expected = "set multiplot layout 2,1;\nplot sin(x),cos(x)"

    assert expected == C.format(input)
  end

  test "Splots" do
    input = G.splots([['x**2+y**2'], ['x**2-y**2']])
    expected = "splot x**2+y**2,x**2-y**2"
    assert expected == C.format([input])
  end
end
