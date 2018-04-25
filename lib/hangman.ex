defmodule Hangman do
  alias Hangman.{GameServer, Supervisor}

  @moduledoc """
  Hangman keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def create_game(user) do
    {:ok, _pid} = DynamicSupervisor.start_child(Supervisor, {GameServer, user})

    :ok
  end

  def set_word(word, user) do
    word_as_list = String.split(word, "", trim: true)

    {:ok, _word} = GameServer.new_word(word_as_list, user)
  end

  def handle_guess(letter, user) do
    {:ok, %{word: word, guesses: guess_list}} = GameServer.get_state(user)

    with {:ok, "valid"} <- valid_guess?(letter, guess_list),
         true <- Enum.member?(word, letter),
         every_index <- get_indexes(word, letter),
         :ok <- save_guess(letter, every_index, user),
         :incomplete <- check_complete(user) do
      {:correct, letter}
    else
      {:complete, word} ->
        {:ok, "Congrats, word: #{word}"}

      false ->
        GameServer.wrong_guess(letter, user)

      {:error, error} ->
        error
    end
  end

  defp save_guess(letter, every_index, user) do
    Enum.each(
      every_index,
      &GameServer.correct_guess(%{value: letter, index: &1}, user)
    )

    :ok
  end

  defp valid_guess?(guess, guess_list) do
    valid? =
      guess
      |> already_guessed?(guess_list)
      |> String.valid?()
      |> only_one_letter?(guess)

    if valid?, do: {:ok, "valid"}, else: {:error, "letter not valid"}
  end

  defp already_guessed?(guess, guess_list) do
    if Enum.member?(guess_list, guess), do: guess
  end

  defp only_one_letter?(_, guess) do
    String.length(guess) == 1
  end

  defp get_indexes(word, letter) do
    Enum.with_index(word) |> Enum.filter(&(elem(&1, 0) == letter)) |> Enum.map(&elem(&1, 1))
  end

  defp check_complete(user) do
    {:ok, %{word: word, correct_guesses: guesses}} = GameServer.get_state(user)

    if Enum.empty?(word -- guesses), do: GameServer.complete(user), else: :incomplete
  end
end
