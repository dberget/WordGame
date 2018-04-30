defmodule Hangman.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: :hangman_server},
      Hangman.HangmanSupervisor,
      Hangman.Repo,
      HangmanWeb.Endpoint,
      Hangman.Presence
    ]

    opts = [strategy: :one_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    HangmanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
