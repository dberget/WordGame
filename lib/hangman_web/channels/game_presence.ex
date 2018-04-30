defmodule Hangman.Presence do
  use Phoenix.Presence,
    otp_app: :Hangman,
    pubsub_server: Hangman.PubSub
end
