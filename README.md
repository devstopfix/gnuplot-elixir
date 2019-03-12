# Gnuplot Elixir

A simple interface from Elixir data structures to the [Gnuplot graphing utility][1] that uses [Erlang Ports][5] to transmit chart data from your application to Gnuplot.

This is a conversion of the [Clojure Gnuplot library][4] by [aphyr][2].

## Usage

The `plot` function takes two arguments:

* a list of commands (each of which is a list of terms)
* a list of datasets

A dataset is a list of points, each point is a list of numbers.

### Scatter plot with a single dataset

Lets compare the [rand functions](http://erlang.org/doc/man/rand.html):

```elixir
alias Gnuplot, as: G

dataset = for _ <- 0..1000, do: [:rand.uniform(), :rand.normal()]
G.plot([
  [:set, :title, "rand uniform vs normal"],
  [:plot, G.list(["-", :with, :points])]
  ], [dataset])
```

Gnuplot will by default open a window containing your plot.

![rand](docs/window.png)

## Installation

When [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `gnuplot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gnuplot, "~> 0.19.70"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/gnuplot](https://hexdocs.pm/gnuplot).

## Testing

Some tests create plots which require `gnuplot` to be installed. They can be be excluded with:

    mix test.watch --exclude gnuplot:true

## Credits and licence

Original design ©2015 [Kyle Kingsbury][2].

Elixir code ©2019 [DEVSTOPFIX LTD][3].

Distributed under the [Eclipse Public License v2][6].



[1]: http://www.gnuplot.info/
[2]: https://github.com/aphyr
[3]: http://www.devstopfix.com/
[4]: https://github.com/aphyr/gnuplot
[5]: http://erlang.org/doc/reference_manual/ports.html
[6]: https://www.eclipse.org/legal/epl-2.0/