defmodule VisNetwork.MixProject do
  use Mix.Project

  @version "0.1.0"
  @description "Elixir bindings to vis-network"

  def project do
    [
      app: :vis_network,
      version: @version,
      description: @description,
      name: "VisNetwork",
      elixir: "~> 1.7",
      deps: deps(),
      docs: docs(),
      package: package(),
      # Modules used by VisNetwork.WxViewer if available
      xref: [exclude: [:wx, :wx_object, :wxFrame, :wxWebView]]
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:jason, "~> 1.2", only: [:dev, :test]},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "VisNetwork",
      source_url: "https://github.com/chamot1111/vis_network",
      source_ref: "v#{@version}"
    ]
  end

  def package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/chamot1111/vis_network"
      }
    ]
  end
end
