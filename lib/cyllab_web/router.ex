defmodule CyllabWeb.Router do
  use CyllabWeb, :router

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

  scope "/", CyllabWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", CyllabWeb do
    pipe_through :api

    get "/", ApiController, :index

    scope "/users" do
      get "/", UserController, :index
      post "/", UserController, :create
    end
  end

end
