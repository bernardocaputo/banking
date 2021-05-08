defmodule BankingWeb.AccountsController do
  @moduledoc """
  The Accounts Controller handle all communication
  regarding authentication and account coming from a client
  """

  use BankingWeb, :controller
  alias Banking.Accounts
  alias Banking.ATM
  alias BankingWeb.BankAccountView

  def authenticate_user(conn, params) do
    with {:ok, user} <- Accounts.authenticate_user(params),
         {:ok, jwt, _claims} <- Guardian.encode_and_sign(Banking.Accounts.Guardian, user) do
      json(conn, %{token: jwt})
    end
  end

  def sign_up(conn, params) do
    with {:ok, user} <- Accounts.create_user(params),
         {:ok, bank_account} <- ATM.create_bank_account(user) do
      conn
      |> put_view(BankAccountView)
      |> render("show.json", bank_account: bank_account)
    end
  end
end
