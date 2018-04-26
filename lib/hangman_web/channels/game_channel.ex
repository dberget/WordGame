defmodule HangmanWeb.GameChannel do
  use HangmanWeb, :channel

  def join("game: " <> game_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("join_game", game_id, socket) do
    {:noreply, socket}
  end
end
