defmodule Hangman.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :host, :string
    field :slug, :string
    field :word, :string
    field :winner, :string
    field :complete, :boolean

    timestamps()
  end

  def creation_changeset(game, attrs) do
    game
    |> change(slug: random_slug())
    |> cast(attrs, [:host, :slug, :word, :winner, :complete])
    |> unique_constraint(:slug)
    |> validate_required([:host, :slug])
  end

  def changeset(game, attrs) do
    game
    |> cast(attrs, [:host, :word, :winner, :complete])
  end

  def random_slug() do
    :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)
  end
end
