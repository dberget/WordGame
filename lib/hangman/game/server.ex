defmodule Hangman.GameServer do
  use GenServer

  # client api
  def start_link(host) do
    GenServer.start_link(
      __MODULE__,
      %{
        host: host.host,
        word: [],
        guesses: [],
        definition: "",
        correct_guesses: [],
        round: 1,
        complete: false
      },
      name: via_tuple(host.slug)
    )
  end

  def new_word(word, definition, host) do
    GenServer.call(via_tuple(host), {:new_word, %{word: word, definition: definition}})
  end

  def new_round(host) do
    GenServer.call(via_tuple(host), {:new_round})
  end

  def correct_guess(letter, host) do
    GenServer.call(via_tuple(host), {:correct_guess, letter})
  end

  def wrong_guess(letter, host) do
    GenServer.call(via_tuple(host), {:wrong_guess, letter})
  end

  def complete(host) do
    GenServer.call(via_tuple(host), {:complete})
  end

  def get_state(host) do
    GenServer.call(via_tuple(host), {:get_state})
  end

  def game_running?(game) do
    GenServer.whereis({:via, Registry, {:hangman_server, game.slug}})
  end

  defp via_tuple(host_id) do
    {:via, Registry, {:hangman_server, host_id}}
  end

  ## Server Callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_call({:new_word, word}, _from, state) do
    new_state = %{
      state
      | word: word.word,
        definition: word.definition,
        guesses: [],
        round: state.round + 1,
        correct_guesses: [],
        complete: false
    }

    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call({:new_round}, _from, state) do
    new_state = %{
      host: state.host,
      word: [],
      guesses: [],
      correct_guesses: [],
      round: state.round + 1,
      complete: false
    }

    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call({:correct_guess, letter}, _from, state) do
    correct_guesses = List.insert_at(state.correct_guesses, letter.index, letter.value)

    new_state = %{
      state
      | correct_guesses: correct_guesses
    }

    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call({:wrong_guess, letter}, _from, state) do
    new_state = %{state | guesses: [letter | state.guesses]}

    {:reply, {:wrong, new_state}, new_state}
  end

  def handle_call({:complete}, _from, state) do
    new_state = %{state | complete: true}

    {:reply, {:complete, new_state}, new_state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
