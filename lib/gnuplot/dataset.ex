defmodule Gnuplot.Dataset do
  @moduledoc """
  Convert Elixir lists to Gnuplot STDIN.

  See http://www.gnuplotting.org/tag/standard-input/
  """

  @type point :: list(number())
  @type t :: list(point())

  @gnuplot_end_row "\n"
  @gnuplot_end_data "\ne\n"

  @doc """
  Convert a list of datasets.

  A dataset is a list of points, each point is a list of numbers.
  """
  @spec format_datasets(list(t())) :: [String.t()]
  def format_datasets(datasets) do
    Enum.flat_map(datasets, &format_dataset/1)
  end

  @spec format_dataset(t()) :: [String.t()]
  defp format_dataset(dataset) do
    dataset
    |> Enum.map(&format_point/1)
    |> Enum.intersperse(@gnuplot_end_row)
    |> Enum.concat([@gnuplot_end_data])
  end

  @spec format_point(point()) :: String.t()
  defp format_point(point) do
    point
    |> Enum.map(&Kernel.to_string/1)
    |> Enum.join(" ")
  end
end
