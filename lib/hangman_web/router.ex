defmodule HangmanWeb.Router do
  use HangmanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HangmanWeb do
    # Use the default browser stack
    pipe_through :browser
    get "/games/:slug", GameController, :show

    resources "/games", GameController
    resources "/users", UserController
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", HangmanWeb do
  #   pipe_through :api
  # end
end
