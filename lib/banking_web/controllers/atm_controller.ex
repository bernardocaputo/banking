defmodule BankingWeb.ATMController do
  use BankingWeb, :controller
  alias Banking.ATM
  alias Banking.Accounts.User
  alias BankingWeb.BankAccountView

  def check_balance(conn, _params) do
    with {:ok, user = %User{}} <- get_current_user(conn),
         {:ok, bank_account} <- ATM.check_balance(user.id) do
      conn
      |> put_view(BankAccountView)
      |> render("show.json", bank_account: bank_account)
    end
  end

  defp get_current_user(conn) do
    {:ok, Guardian.Plug.current_resource(conn)}
  end
end
