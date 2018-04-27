defmodule HangmanWeb.GameController do
  use HangmanWeb, :controller
  alias Hangman.{Games, Game}

  def index(conn, _params) do
    changeset = Games.change_game(%Game{})
    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"slug" => slug}) do
    game = Games.get_game!(slug)
    is_host? = get_session(conn, :host)
    Hangman.is_running_or_start(game)

    render(conn, "show.html", game: game, host: is_host?)
  end

  def create(conn, %{"game" => game_params}) do
    case Games.create_game(game_params) do
      {:ok, game} ->
        case Hangman.start_game(game) do
          :ok ->
            conn
            |> put_session(:host, true)
            |> put_flash(:info, "Game created successfully.")
            |> redirect(to: game_path(conn, :show, game.slug))

          _ ->
            render(conn, "new.html")
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
