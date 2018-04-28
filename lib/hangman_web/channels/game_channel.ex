defmodule HangmanWeb.GameChannel do
  use HangmanWeb, :channel

  def join("game: " <> game_slug, _params, socket) do
    socket = assign(socket, :slug, game_slug)

    {:ok, socket}
  end

  def handle_in("get_state", _params, socket) do
    slug = socket.assigns[:slug]
    {:ok, state} = Hangman.get_state(slug)

    {:reply, {:ok, state}, socket}
  end

  def handle_in("new_guess", params, socket) do
    slug = socket.assigns[:slug]
    {:ok, state} = Hangman.handle_guess(params["guess"], slug)

    broadcast!(socket, "new_guess", state)

    {:reply, :ok, socket}
  end

  def handle_in("new_word", params, socket) do
    slug = socket.assigns[:slug]
    {:ok, state} = Hangman.set_word(params["word"], slug)

    broadcast!(socket, "new_word", state)

    {:reply, :ok, socket}
  end
end
