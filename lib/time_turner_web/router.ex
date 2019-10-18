defmodule TimeTurnerWeb.Router do
  use TimeTurnerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimeTurnerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/operator", TimeTurnerWeb do
    pipe_through :browser

    live "/order/:order_id", OrderLive
    live "/", OperatorLive
    live "/customer/:customer_id", CustomerLive
  end
end
