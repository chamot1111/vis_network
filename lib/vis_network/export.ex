defmodule VisNetwork.Export do
  @moduledoc """
  Various export methods for a `VisNetwork` specification.

  All of the export functions depend on the `:jason` package.
  Additionally the PNG, SVG and PDF exports rely on npm packages,
  so you will need Node.js, `npm`, and the following dependencies:

      npm install -g vega vis-network canvas
      # or in the current directory
      npm install vega vis-network canvas
  """

  alias VisNetwork.Utils

  @doc """
  Saves a `VisNetwork` specification to file in one of
  the supported formats.

  ## Options

    * `:format` - the format to export the graphic as,
      must be either of: `:json`, `:html`.
      By default the format is inferred from the file extension.
  """
  @spec save!(VisNetwork.t(), binary(), keyword()) :: :ok
  def save!(vl, path, opts \\ []) do
    format =
      Keyword.get_lazy(opts, :format, fn ->
        path |> Path.extname() |> String.trim_leading(".") |> String.to_existing_atom()
      end)

    content =
      case format do
        :json ->
          to_json(vl)

        :html ->
          to_html(vl)

        _ ->
          raise ArgumentError,
                "unsupported export format, expected :json, :html, got: #{inspect(format)}"
      end

    File.write!(path, content)
  end

  @compile {:no_warn_undefined, {Jason, :encode!, 1}}

  @doc """
  Returns the underlying vis-network specification as JSON.
  """
  @spec to_json(VisNetwork.t()) :: String.t()
  def to_json(vl) do
    Utils.assert_jason!("to_json/1")

    vl
    |> VisNetwork.to_spec()
    |> Jason.encode!()
  end

  @doc """
  Builds an HTML page that renders the given graphic.

  The HTML page loads necessary JavaScript dependencies from a CDN
  and then renders the graphic in a root element.
  """
  @spec to_html(VisNetwork.t()) :: binary()
  def to_html(vl) do
    json = to_json(vl)

    """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Vis network graphic</title>
        <style>
            body {
                font: 10pt sans;
            }

            #mynetwork {
                width: 100%;
                height: 800px;
                border: 1px solid lightgray;
            }
        </style>

        <link rel="stylesheet" href="vis-network.css">
    </head>

    <body>
        <div id="mynetwork"></div>
        <p id="selection"></p>
        <script src="vis-network.js"></script>

        <script>
            var nodes = null;
            var edges = null;
            var network = null;

            function destroy() {
                if (network !== null) {
                    network.destroy();
                    network = null;
                }
            }

            function draw() {
                destroy();
                var spec = JSON.parse("#{escape_double_quotes(json)}");
                network = new vis.Network(container, spec.data, spec.options);
            }

            window.addEventListener("load", () => {
                draw();
            });
        </script>
    </body>
    </html>
    """
  end

  defp escape_double_quotes(json) do
    String.replace(json, ~s{"}, ~s{\\"})
  end

end
