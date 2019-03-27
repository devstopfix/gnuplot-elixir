defmodule Gnuplot.Bin do
  @moduledoc false

  @doc """
  Find the gnuplot executable.
  """
  @spec gnuplot_bin() :: {:error, :gnuplot_missing} | {:ok, :file.name()}
  def gnuplot_bin do
    case :os.find_executable(String.to_charlist("gnuplot")) do
      false -> {:error, :gnuplot_missing}
      path -> {:ok, path}
    end
  end
end
