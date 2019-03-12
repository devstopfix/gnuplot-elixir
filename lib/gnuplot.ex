defmodule Gnuplot do
  @moduledoc """
  Transmit Elixir data to Gnuplot graphing library.
  """

  import Gnuplot.Datasets

  @doc """
  Transmit commands and data streams.

  ## Examples

      iex> Gnuplot.plot()
      :error

  """
  def plot(_commands, datasets) do
    with {:ok, path} = gnuplot_bin(),
         _data = format_datasets(datasets) do
      {:ok, path}
    end
  end

  def list(_xs), do: []

  def gnuplot_bin do
    case System.find_executable("gnuplot") do
      nil -> {:error, :gnuplot_missing}
      path -> {:ok, path}
    end
  end

end
