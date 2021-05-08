defmodule BankingWeb.ATMController do
  @moduledoc """
  The ATM Controller handle all actions that a person can do in his
  bank account, i.e: check balance, deposit and withdrahal money
  """

  use BankingWeb, :controller
  alias Banking.Accounts.User
  alias Banking.ATM
  alias BankingWeb.BankAccountView

  @doc """
  Return user's bank account
  """
  @spec show_bank_account(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show_bank_account(conn, _params) do
    with {:ok, user = %User{}} <- get_current_user(conn),
         {:ok, bank_account} <- ATM.show_bank_account(user.id) do
      conn
      |> put_view(BankAccountView)
      |> render("show.json", bank_account: bank_account)
    end
  end

  @doc """
  Deposit money to current user's bank account
  """
  @spec deposit_to(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def deposit_to(conn, %{"deposit_amount" => deposit_amount}) do
    with {:ok, user = %User{}} <- get_current_user(conn),
         {:ok, bank_account} <- ATM.show_bank_account(user.id),
         {:ok, bank_account_updated} <- ATM.deposit_to(bank_account, deposit_amount) do
      conn
      |> put_view(BankAccountView)
      |> render("show.json", bank_account: bank_account_updated)
    end
  end

  @doc """
  Withdrawal money from current user's bank account
  """
  @spec withdrawal_from(Plug.Conn.t(), map()) :: Plug.Conn.t()
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
