defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :auth do
    plug Banking.Accounts.Pipeline
  end

  pipeline :ensure_authed_access do
    plug Guardian.Plug.EnsureAuthenticated, error_handler: Banking.Accounts.ErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankingWeb do
    pipe_through [:api, :auth]

    post "/authenticate_user", AccountsController, :authenticate_user
  end

  scope "/", BankingWeb do
    pipe_through [:api, :auth, :ensure_authed_access]

    get "/check_balance", ATMController, :check_balance
  end

  # Other scopes may use custom stacks.
  # scope "/api", BankingWeb do
  #   pipe_through :api
  # end
end
