defmodule Gnuplot.Dataset do
  @moduledoc """
  Convert Elixir lists to Gnuplot STDIN.

  See http://www.gnuplotting.org/tag/standard-input/
  """

  @type point :: list(number()) | tuple()
  @type t :: list(point())

  @gnuplot_end_row "\n"
  @gnuplot_end_data "\ne\n"

  @doc """
  Format datasets into Gnuplot STDIN format. Datasets must be Enumerable and can be Streams.

  A dataset is a list of points, each point is a list of numbers.
  """
  def format_datasets(datasets) do
    Stream.flat_map(datasets, &format_dataset/1)
  end

  defp format_dataset(dataset) do
    dataset
    |> Stream.map(&format_point/1)
    |> Stream.intersperse(@gnuplot_end_row)
    |> Stream.concat([@gnuplot_end_data])
  end

  @spec format_point(point()) :: String.t()
  defp format_point(point) when is_tuple(point) do
    point |> Tuple.to_list() |> format_point()
  end

  defp format_point(point) do
    point
    |> Enum.map(&Kernel.to_string/1)
    |> Enum.join(" ")
  end
end
