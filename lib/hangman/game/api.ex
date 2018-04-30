defmodule Hangman.Api do
  @key Application.get_env(:hangman, :api_key)

  def get_word do
    {:ok, response} =
      HTTPoison.get(
        "https://wordsapiv1.p.mashape.com/words/?random=true",
        "X-Mashape-Key": @key
      )

    parse_response(response)
  end

  def parse_response(resp) do
    {:ok, body} = Poison.decode(resp.body)

    case body["results"] do
      nil ->
        get_word()

      _ ->
        format_response(body)
    end
  end

  def format_response(body) do
    %{
      word: String.split(body["word"]) |> Enum.join(),
      definition: List.first(body["results"])["definition"]
    }
  end
end
