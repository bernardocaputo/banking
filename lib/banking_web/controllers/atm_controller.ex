defmodule BankingWeb.ATMController do
  use BankingWeb, :controller
  alias Banking.ATM
  alias Banking.Accounts.User
  alias BankingWeb.BankAccountView

  def show_bank_account(conn, _params) do
    with {:ok, user = %User{}} <- get_current_user(conn),
         {:ok, bank_account} <- ATM.show_bank_account(user.id) do
      conn
      |> put_view(BankAccountView)
      |> render("show.json", bank_account: bank_account)
    end
  end

  def deposit_to(conn, %{"deposit_amount" => deposit_amount}) do
    with {:ok, user = %User{}} <- get_current_user(conn),
         {:ok, bank_account} <- ATM.show_bank_account(user.id),
         {:ok, bank_account_updated} <- ATM.deposit_to(bank_account, deposit_amount) do
      conn
      |> put_view(BankAccountView)
      |> render("show.json", bank_account: bank_account_updated)
    end
  end

  def withdrawal_from(conn, %{"withdrawal_amount" => withdrawal_amount}) do
    with {:ok, user = %User{}} <- get_current_user(conn),
         {:ok, bank_account} <- ATM.show_bank_account(user.id),
         {:ok, bank_account_updated} <- ATM.withdrawal_from(bank_account, withdrawal_amount) do
      conn
      |> put_view(BankAccountView)
      |> render("show.json", bank_account: bank_account_updated)
    end
  end

  defp get_current_user(conn) do
    {:ok, Guardian.Plug.current_resource(conn)}
  end
end
