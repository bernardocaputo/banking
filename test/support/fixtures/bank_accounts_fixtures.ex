defmodule Banking.BankAccountsFixtures do
  alias Banking.AccountsFixtures
  alias Banking.ATM.BankAccount
  alias Banking.Repo

  defp random_balance, do: Enum.random(0..100)

  def valid_bank_account_attributes(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()

    Enum.into(attrs, %{
      balance: random_balance(),
      user_id: user.id
    })
  end

  def bank_account_fixture(attrs \\ %{}) do
    {:ok, bank_account} =
      attrs
      |> valid_bank_account_attributes()
      |> BankAccount.create_changeset()
      |> Repo.insert()

    bank_account
  end
end
