defmodule CronGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :cron_generator,
      version: "0.1.0",
      description: package_description(),
      elixir: "~> 1.11",
      name: package_name(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package_info(),
      source_url: package_source_url()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps(), do: []

  defp package_name(), do: "gen_cron"
  defp package_description(), do: "A CRON-like GenServer stub generator"

  defp package_info() do
    [
      name: "gen_cron",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => package_source_url()}
    ]
  end

  defp package_source_url(), do: "https://github.com/peterkrauz/gen_cron"
end
