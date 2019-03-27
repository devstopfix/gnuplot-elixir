defmodule Gnuplot do
  @moduledoc """
  Interface to the Gnuplot graphing library.

  Plot a sine function where Gnuplot generates the samples:

      Gnuplot.plot([
        ~w(set autoscale)a,
        ~w(set samples 800)a,
        [:plot, -30..20, 'sin(x*20)*atan(x)']
      ])

  Plot a sine function where your program generates the data:

      Gnuplot.plot([
          [:plot, "-", :with, :lines :title, "sin(x*20)*atan(x)"]
        ],
        [
          for x <- -30_000..20_000, do: [x / 1000.0 , :math.sin(x * 20 / 1000.0) * :math.atan(x / 1000.0) ]
        ]
      )

  """

  alias Gnuplot.Commands
  import Gnuplot.Dataset
  import Gnuplot.Bin

  @type command_term :: atom() | charlist() | number() | Range.t() | String.t()

  @type command :: nonempty_list(command_term())

  @doc """
  Transmit commands without dataset.
  """
  @spec plot(list(command())) :: {:ok, String.t()} | {:error, term()}
  def plot(commands), do: plot(commands, [])

  @doc """
  Transmit commands and datasets to Gnuplot.

  ## Examples

      iex> Gnuplot.plot([[:plot, "-", :with, :lines]], [[[0, 0], [1, 2], [2, 4]]])
      {:ok, "plot \"-\" with lines"}

  """
  @spec plot(list(command()), list(Dataset.t())) :: {:ok, String.t()} | {:error, term()}
  def plot(commands, datasets) do
    with {:ok, path} = gnuplot_bin(),
         cmd = Commands.format(commands),
         args = ["-p", "-e", cmd],
         port = Port.open({:spawn_executable, path}, [:binary, args: args]) do
      transmit(port, datasets)
      {_, :close} = send(port, {self(), :close})
      {:ok, cmd}
    end
  end

  @spec transmit(port(), list(Dataset.t())) :: :ok
  defp transmit(port, datasets) do
    :ok =
      datasets
      |> format_datasets()
      |> Stream.each(fn row -> send(port, {self(), {:command, row}}) end)
      |> Stream.run()
  end

  @doc "Build a comma separated list from a list of terms."
  def list(xs) when is_list(xs), do: %Commands.List{xs: xs}

  @doc "Build a comma separated list of two terms."
  def list(a, b), do: %Commands.List{xs: [a, b]}

  @doc "Build a comma separated list of three terms."
  def list(a, b, c), do: %Commands.List{xs: [a, b, c]}

  @doc "Build a comma separated list of four terms."
  def list(a, b, c, d), do: %Commands.List{xs: [a, b, c, d]}

  @doc "Build a comma separated list of five terms."
  def list(a, b, c, d, e), do: %Commands.List{xs: [a, b, c, d, e]}

  @doc "Build a comma separated list of six terms."
  def list(a, b, c, d, e, f), do: %Commands.List{xs: [a, b, c, d, e, f]}
end
