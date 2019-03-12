defmodule GnuplotTest do
  use ExUnit.Case
  alias Gnuplot, as: G
  alias Gnuplot.Commands, as: C

  test "Gnuplot is installed" do
    assert {:ok, path} = G.gnuplot_bin()
    assert File.exists?(path)
  end

  test "Simple plot" do
    expected = "plot '-' with lines"
    assert {:ok, expected} == G.plot([[:plot, G.list(["-", :with, :lines])]], [[[0, 0], [1, 2], [2, 4]]])
  end

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

  test "Write PNG" do
    {tmp, 0} = System.cmd("mktemp")
    png = String.trim_trailing(tmp, "\n") <> ".PNG"

    # assert {:ok, _} == G.plot([
    #   # [:a, :=, 0.9],
    #   [:plot, G.list(["-", :with, :lines])]], [])

  end

end
