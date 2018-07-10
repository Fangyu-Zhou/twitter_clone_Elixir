defmodule Twitter.Router do
  use Twitter.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
#    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :csrf do
      plug :protect_from_forgery # to here
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Twitter do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/register", RegisterController, :register
  end

  # Other scopes may use custom stacks.
  # scope "/api", Twitter do
  #   pipe_through :api
  # end
end
