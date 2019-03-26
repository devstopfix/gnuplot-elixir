# Gnuplot from Erlang

This document [explains how to use Elixir libraries from Erlang](https://github.com/barrel-db/rebar3_elixir_compile).

Make a new project:

    rebar3 new lib plotter
    cd plotter


Modify the `rebar.config`:

```erlang
{plugins, [
    { rebar3_elixir_compile, ".*", {git, "https://github.com/barrel-db/rebar3_elixir_compile.git", {branch, "master"}}}
]}.

{deps, [
   {faker, {elixir, "faker" ,"0.6.0"}},
   {gnuplot, {elixir, "gnuplot", "0.19.73"}}
]}.

{provider_hooks, [
  {pre, [{compile, {ex, compile}}]}
]}.

{elixir_opts, 
  [
    {env, dev}
  ]
}.
```

Open a shell:


```
rebar3 as test shell
```

Generate a plot:

```erlang
> 'Elixir.Gnuplot':plot([[plot, "sin(x)"]]).

{ok,<<"plot sin(x)">>}
```

