defmodule Gnuplot.Commands do
  @moduledoc """
  Protocols that convert Elixir structures to Gnuplot commands.
  """

  defprotocol Command do
    @spec formatg(term()) :: String.t()
    def formatg(cmd)
  end

  defimpl Command, for: Atom do
    def formatg(a), do: Atom.to_string(a)
  end

  defimpl Command, for: Float do
    def formatg(x), do: Float.to_string(x)
  end

  defimpl Command, for: Integer do
    def formatg(x), do: Integer.to_string(x)
  end

  defimpl Command, for: BitString do
    def formatg(s) when is_binary(s), do: "'" <> String.replace(s, "'", "\\'") <> "'"
  end

  defimpl Command, for: Range do
    def formatg(%{first: f, last: l}) do
      "[" <> Command.formatg(f) <> ":" <> Command.formatg(l) <> "]"
    end
  end

  defimpl Command, for: List do
    def formatg(xs)

    def formatg(xs) do
      xs
      |> Enum.map(fn cmd -> Command.formatg(cmd) end)
      |> Enum.join(" ")
    end
  end

  defmodule List do
    @moduledoc "Comma separated lists"
    defstruct xs: []
  end

  defimpl Command, for: List do
    def formatg(%{xs: xs}) do
      xs
      |> Enum.map(fn cmd -> Command.formatg(cmd) end)
      |> Enum.join(",")
    end
  end

  @spec format(list(list())) :: String.t()
  def format(cmds) do
    cmds
    |> Enum.map(fn cmd -> Command.formatg(cmd) end)
    |> Enum.join(";\n")
  end
end
