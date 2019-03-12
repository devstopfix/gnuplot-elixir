defmodule Gnuplot do
  @moduledoc """
  Transmit Elixir data to Gnuplot graphing library.
  """

  @doc """
  Transmit commands and data streams.

  ## Examples

      iex> Gnuplot.plot()
      :error

  """
  def plot(_commands, _datasets) do
    # with
    #   {:ok, path} <- gnuplot_bin()
    # do
    #   1 + 2
    # else
    #   e -> e
    # end
  end

  def list(_xs), do: []

  def gnuplot_bin do
    case System.find_executable("gnuplot") do
      nil -> {:error, :gnuplot_missing}
      path -> {:ok, path}
    end
  end

end
