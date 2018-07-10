defmodule TwitterClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :twitter_client,
      escript: escript(),
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def escript do
      [main_module: MyApp.CLI]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:jose, :httpoison, :websockex],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:httpoison, "~> 0.13"},
        {:poison, "~> 3.1"},
        {:websockex, "~> 0.4.0"},
        {:phoenixchannelclient, "~> 0.1.0"},
        {:jose, "~> 1.8"},
        {:ojson, "~> 1.0"},
        {:ex_crypto, "~> 0.7.1"},
        {:json_web_token, "~> 0.2"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

end
