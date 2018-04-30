# defmodule HangmanWeb.SessionController do
#   use HangmanWeb, :controller
#   alias Hangman.Games

#   def new(conn, _params) do
#     render
#   end

#   def create(conn, %{"user" => user, "slug" => slug}) do
#     token = Phoenix.Token.sign(conn, "user socket", user)
#     game = Games.get_game!(slug)

#     conn
#     |> put_session(:user_token, token)
#     |> redirect(to: game_path(conn, :show, game.slug))
#   end

#   def destroy(conn, _params) do
#     render conn, "index.html"
#   end
# end
