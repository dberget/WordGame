defmodule Hangman.Repo.Migrations.CreateGameTable do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :host, :string
      add :slug, :string
      add :word, :string
      add :winner, :string
      add :complete, :boolean, default: false

      timestamps()
    end
  end
end
