defmodule Hangman.Repo.Migrations.UniqueSlugIndex do
  use Ecto.Migration

  def change do
    create(unique_index(:games, [:slug]))
  end
end
