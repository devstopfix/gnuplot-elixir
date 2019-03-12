defmodule GnuplotTest do
  use ExUnit.Case
  alias Gnuplot, as: G

  test "Gnuplot is installed" do
    assert {:ok, path} = G.gnuplot_bin()
    assert File.exists?(path)
  end

  test "Simple plot" do
    assert {:ok, cmd} = G.plot([:plot, G.list(["-", :with, :lines])], [[[0, 0], [1, 2], [2, 4]]])
  end
end
