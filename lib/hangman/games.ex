defmodule Hangman.Games do
  import Ecto.Query, warn: false
  alias Hangman.{Repo, Game}

  @doc """
  only queries active games by default
  """
  def list_all(opts \\ %{complete: false}) do
    Game
    |> where(complete: ^opts.complete)
    |> Repo.all()
  end

  def get_game!(slug), do: Repo.get_by!(Game, slug: slug)

  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.creation_changeset(attrs)
    |> Repo.insert()
  end

  def update_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end
end
