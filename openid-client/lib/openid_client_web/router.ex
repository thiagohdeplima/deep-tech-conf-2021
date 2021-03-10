defmodule OpenIDClientWeb.Router do
  use OpenIDClientWeb, :router

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

  scope "/", OpenIDClientWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/session", PageController, :show
  end
end
