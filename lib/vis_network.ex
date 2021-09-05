defmodule VisNetwork do
  @moduledoc """
  Elixir bindings to [vis-network](https://github.com/visjs/vis-network).
  """

  defstruct spec: %{}

  alias VisNetwork.Utils

  @type t :: %__MODULE__{
          spec: spec()
        }

  @type spec :: map()

  @doc """
  Returns a new specification wrapped in the `VisNetwork` struct.

  All provided options are converted to top-level properties
  of the specification.

  ## Examples

      Vl.new(
        title: "My graph",
        width: 200,
        height: 200
      )
      |> ...


  See [the docs](https://vega.github.io/vis-network/docs/spec.html) for more details.
  """
  @spec new(keyword()) :: t()
  def new(opts \\ []) do
    vn = %VisNetwork{}
    vn_props = opts_to_vn_props(opts)
    update_in(vn.spec, fn spec -> Map.merge(spec, vn_props) end)
  end

  @compile {:no_warn_undefined, {Jason, :decode!, 1}}

  @doc """
  Parses the given vis-network JSON specification
  and wraps in the `VisNetwork` struct for further processing.

  ## Examples

      Vn.from_json(\"\"\"
      {
        "data": {
          "nodes": [{"id": "1", "label": "lbl1", "color": "rgb(68,0,0)"}, {"id": "2", "label": "lbl2", "color": "rgb(0,100,0)"}],
          "edges": [{"id": "1-2", "from": "1", "to": "2", value: 1, arrows: "to"}]
        },
        "options": {
          "configure": {
              "enabled": false,
          },
          "nodes": {
              "shape": "dot",
              "size": 16,
          },
          "physics": {
              "forceAtlas2Based": {
              "gravitationalConstant": -26,
              "centralGravity": 0.005,
              "springLength": 230,
              "springConstant": 0.18,
              },
              "maxVelocity": 146,
              "solver": "forceAtlas2Based",
              "timestep": 0.35,
              "stabilization": { "iterations": 150 },
          },
        }
      }
      \"\"\")


  See [the docs](https://visjs.github.io/vis-network/docs/network/) for more details.
  """
  @spec from_json(String.t()) :: t()
  def from_json(json) do
    Utils.assert_jason!("from_json/1")

    json
    |> Jason.decode!()
    |> from_spec()
  end

  @doc """
  Wraps the given vis-network specification in the `VisNetwork`
  struct for further processing.

  There is also `from_json/1` that handles JSON parsing for you.

  See [the docs](https://vega.github.io/vis-network/docs/spec.html) for more details.
  """
  @spec from_spec(spec()) :: t()
  def from_spec(spec) do
    %VisNetwork{spec: spec}
  end

  @doc """
  Returns the underlying vis-network specification.

  The result is a nested Elixir datastructure that serializes
  to vis-network JSON specification.

  See [the docs](https://vega.github.io/vis-network/docs/spec.html) for more details.
  """
  @spec to_spec(t()) :: spec()
  def to_spec(vn) do
    vn.spec
  end

  # Helpers

  defp opts_to_vn_props(opts) do
    opts |> Map.new() |> to_vn()
  end

  defp to_vn(value) when value in [true, false, nil], do: value

  defp to_vn(atom) when is_atom(atom), do: to_vn_key(atom)

  defp to_vn(map) when is_map(map) do
    Map.new(map, fn {key, value} ->
      {to_vn(key), to_vn(value)}
    end)
  end

  defp to_vn([{key, _} | _] = keyword) when is_atom(key) do
    Map.new(keyword, fn {key, value} ->
      {to_vn(key), to_vn(value)}
    end)
  end

  defp to_vn(list) when is_list(list) do
    Enum.map(list, &to_vn/1)
  end

  defp to_vn(value), do: value

  defp to_vn_key(key) when is_atom(key) do
    key |> to_string() |> snake_to_camel()
  end

  defp snake_to_camel(string) do
    [part | parts] = String.split(string, "_")
    Enum.join([String.downcase(part, :ascii) | Enum.map(parts, &String.capitalize(&1, :ascii))])
  end
end
