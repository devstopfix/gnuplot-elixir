defmodule GnuplotTest do
  use ExUnit.Case
  doctest Gnuplot

  test "greets the world" do
    assert Gnuplot.hello() == :world
  end
end
