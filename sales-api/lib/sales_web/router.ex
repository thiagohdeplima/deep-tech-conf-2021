defmodule SalesWeb.Router do
  use SalesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug SalesWeb.Jwks
  end

  scope "/api", SalesWeb do
    pipe_through :api

    get  "/orders", OrderController, :index
    post "/orders", OrderController, :create

    get "/products", ProductController, :index
  end
end
