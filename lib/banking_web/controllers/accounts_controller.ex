defmodule BankingWeb.AccountsController do
  use BankingWeb, :controller
  alias Banking.Accounts

  def authenticate_user(conn, params) do
    with {:ok, user} <- Accounts.authenticate_user(params),
         {:ok, jwt, _claims} <- Guardian.encode_and_sign(Banking.Accounts.Guardian, user) do
      json(conn, %{token: jwt})
    end
  end
end
