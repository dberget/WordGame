defmodule Hangman do
  alias Hangman.{GameServer, HangmanSupervisor}

  defstruct [
    :user,
    :errors,
    :valid,
    :guess,
    :guesses,
    :word,
    :indexes,
    complete: false,
    correct: false
  ]

  @moduledoc """
  Hangman keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def start_game(game) do
    {:ok, _pid} = DynamicSupervisor.start_child(HangmanSupervisor, {GameServer, game})

    :ok
  end

  def running?(game) do
    case GameServer.game_running?(game) do
      nil ->
        start_game(game)

      pid ->
        {:ok, pid}
    end
  end

  def set_word(word, user) do
    word_as_list = String.split(word, "", trim: true)

    {:ok, _word} = GameServer.new_word(word_as_list, user)
  end

  def new_round(user), do: {:ok, _msg} = GameServer.new_round(user)

  def handle_guess(letter, user) do
    {:ok, %{word: word, guesses: guess_list}} = GameServer.get_state(user)

    game_struct =
      %Hangman{user: user, guess: letter, guesses: guess_list, word: word}
      |> valid_guess?
      |> handle_save_guess
      |> check_complete
      |> handle_errors

    handle_response(game_struct)
  end

  defp valid_guess?(%Hangman{guesses: guess_list, guess: guess} = game_struct) do
    valid? = !Enum.member?(guess_list, guess) && String.valid?(guess) && String.length(guess) == 1

    %Hangman{game_struct | valid: valid?}
  end

  defp handle_save_guess(%Hangman{valid: false} = game_struct), do: game_struct

  defp handle_save_guess(game_struct) do
    game_struct
    |> guess_correct?()
    |> get_indexes()
    |> save_guess
  end

  defp check_complete(%Hangman{valid: false} = game_struct), do: game_struct

  defp check_complete(%Hangman{correct: false} = game_struct), do: game_struct

  defp check_complete(%Hangman{user: user} = game_struct) do
    {:ok, %{word: word, correct_guesses: guesses}} = GameServer.get_state(user)

    complete? = word == guesses

    if complete?, do: GameServer.complete(user)

    %Hangman{game_struct | complete: complete?}
  end

  defp guess_correct?(%Hangman{word: word, guess: guess} = game_struct) do
    %Hangman{game_struct | correct: Enum.member?(word, guess)}
  end

  defp save_guess(%Hangman{valid: false} = game_struct), do: game_struct

  defp save_guess(
         %Hangman{indexes: indexes, user: user, correct: true, guess: guess} = game_struct
       ) do
    Enum.each(indexes, &GameServer.correct_guess(%{value: guess, index: &1}, user))

    game_struct
  end

  defp save_guess(%Hangman{user: user, guess: guess, correct: false} = game_struct) do
    GameServer.wrong_guess(guess, user)

    game_struct
  end

  defp get_indexes(%Hangman{correct: false} = game_struct), do: game_struct

  defp get_indexes(%Hangman{word: word, guess: letter} = game_struct) do
    indexes =
      Enum.with_index(word) |> Enum.filter(&(elem(&1, 0) == letter)) |> Enum.map(&elem(&1, 1))

    %Hangman{game_struct | indexes: indexes}
  end

  defp handle_errors(%Hangman{errors: nil} = game_struct), do: game_struct
  defp handle_errors(%Hangman{errors: errors}), do: IO.inspect(errors)

  defp handle_response(%Hangman{valid: false, guess: letter}), do: {:ok, "#{letter} not valid"}
  defp handle_response(%Hangman{complete: true, word: word}), do: {:ok, "Winner! It was #{word}!"}
  defp handle_response(%Hangman{correct: true, guess: letter}), do: {:ok, "#{letter} is Correct!"}
  defp handle_response(%Hangman{correct: false, guess: letter}), do: {:ok, "#{letter} is Wrong!"}
end
