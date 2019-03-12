defmodule Gnuplot do
  @moduledoc """
  Transmit Elixir data to Gnuplot graphing library.
  """

  alias Gnuplot.Commands
  import Gnuplot.Datasets

  @doc """
  Transmit commands and data streams.

  ## Examples

      iex> Gnuplot.plot([:plot, G.list(["-", :with, :lines])], [[[0, 0], [1, 2], [2, 4]]])
      {:ok, ...}

  """
  def plot(commands, datasets) do
    with {:ok, path} = gnuplot_bin(),
         cmd = Commands.format(commands),
         data = format_datasets(datasets),
         args = ["-p", "-e", cmd],
         port = Port.open({:spawn_executable, path}, [:binary, args: args]) do
      Enum.each(data, fn row -> send(port, {self(), {:command, row}}) end)
      {_, :close} = send(port, {self(), :close})
      {:ok, cmd}
    end
  end

  def list(a), do: %Commands.List{xs: [a]}
  def list(a, b), do: %Commands.List{xs: [a, b]}

  @spec gnuplot_bin() :: {:error, :gnuplot_missing} | {:ok, :file.name()}
  def gnuplot_bin do
    case :os.find_executable(String.to_charlist("gnuplot")) do
      false -> {:error, :gnuplot_missing}
      path -> {:ok, path}
    end
  end
end
