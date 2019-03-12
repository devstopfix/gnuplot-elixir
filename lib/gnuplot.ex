defmodule Gnuplot do
  @moduledoc """
  Interface to the Gnuplot graphing library.

  Plot a sine wave:

      Gnuplot.plot([
        ~w(set autoscale)a,
        ~w(set samples 800)a,
        [:plot, -30..20, 'sin(x*20)*atan(x)']
      ])

  """

  alias Gnuplot.Commands
  import Gnuplot.Dataset

  @doc """
  Transmit commands and data streams to gnuplot.

  ## Examples

      iex> Gnuplot.plot([[:plot, "-", :with, :lines]], [[[0, 0], [1, 2], [2, 4]]])
      {:ok, "..."}

  """
  @spec plot(list(term()), list(Dataset.t())) :: {:ok, String.t()} | {:error, term()}
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

  @doc """
  Plot a function that has no dataset.
  """
  @spec plot(list(term())) :: {:ok, String.t()} | {:error, term()}
  def plot(commands), do: plot(commands, [])

  @doc """
  Build a comma separated list.
  """
  def list(a), do: %Commands.List{xs: [a]}

  def list(a, b), do: %Commands.List{xs: [a, b]}

  def list(a, b, c), do: %Commands.List{xs: [a, b, c]}

  def list(a, b, c, d), do: %Commands.List{xs: [a, b, c, d]}

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
