# VisNetwork

Elixir bindings to [vis-network](https://visjs.github.io/vis-network/docs/network/).

You can use it inside Livebook to plot network.

[See the documentation](https://hexdocs.pm/vis_network).

## Installation

### Inside Livebook

You most likely want to use VisNetwork in [Livebook](https://github.com/elixir-nx/livebook),
in which case you can call `Mix.install/2`:

```elixir
Mix.install([
  {:vis_network, "~> 0.1.0"},
  {:kino, "~> 0.1.0"}
])
```

You will also want [Kino](https://github.com/elixir-nx/kino) to ensure
Livebook renders the graphics nicely. There is an introductory guide
to VisNetwork in the "Explore" section of your Livebook application.

### In Mix projects

You can add the `:vis_network` dependency to your `mix.exs`:

```elixir
def deps do
  [
    {:vis_network, "~> 0.1.0"}
  ]
end
```
