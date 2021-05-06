defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :auth do
    plug(Banking.Accounts.Pipeline)
  end

  pipeline :ensure_authed_access do
    plug(Guardian.Plug.EnsureAuthenticated, error_handler: Banking.Accounts.ErrorHandler)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", BankingWeb do
    pipe_through([:api, :auth])

    post("/authenticate_user", AccountsController, :authenticate_user)
    post("/sign_up", AccountsController, :sign_up)
  end

  scope "/", BankingWeb do
    pipe_through([:api, :auth, :ensure_authed_access])

    get("/show_bank_account", ATMController, :show_bank_account)
    post("/deposit_to", ATMController, :deposit_to)
    post("/withdrawal_from", ATMController, :withdrawal_from)
  end
end
