defmodule HangmanWeb.GameController do
  use HangmanWeb, :controller
  alias Hangman.{Games, Game}

  def index(conn, _params) do
    changeset = Games.change_game(%Game{})
    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"slug" => slug}) do
    game = Games.get_game!(slug)

    render(conn, "show.html", game: game)
  end

  def create(conn, %{"game" => game_params}) do
    case Games.create_game(game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: game_path(conn, :show, game.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
